import { inject, injectable } from "inversify";
import _ from "lodash";
import { z } from "zod";
import { ApiHttpBaseController } from "../../../../api/http/controller";
import { IDatabase } from "../../../../db/access";
import { OASZodMetadata } from "../../../../lib/openapi";
import { SqlUtils } from "../../../../db/utils";
import { AppRequestScope } from "../../../ioc";
import { THttpRequestBody } from "../../../server/http/body";
import { RoutePrefix, Security, Tags } from "../../../server/http/controller";
import { Consumes, Post, Produces, Summary, Throws } from "../../../server/http/operation";
import { Body, Optional, Query } from "../../../server/http/parameter";
import { AppSecurityPolicies } from "../../../server/security";
import { AccessDeniedError } from "../../../../lib/error2/security";
import { ObjectUtils } from "../../../../lib/utils";

const SQL_SET_COMMAND = /(?:^|;)\s*SET\s+(?:(LOCAL|SESSION)\s+)?(\w+)\s*(?:=|TO)\s*([^;]+);/gi;
const SQL_TABLE_REFERENCE = /((?:FROM|JOIN|TABLE|INDEX)\s+"?)(\w+)("?\."?\w+)/gi;
const SQL_FUNCTION_CALL = /(?:"?(\w+)"?\.)(\w+\([^)]+\))/g;
const SQL_SCHEMA_COMMANDS = /\b(CREATE|DROP|ALTER|TRUNCATE)\b/gi;

interface IQueryResult extends z.infer<typeof QueryResult> {}
const QueryResult = OASZodMetadata.setSchemaName(
    z.strictObject({
        command: z.string().optional(),
        fields: z.array(
            z.strictObject({
                name: z.string(),
                tableID: z.number(),
                columnID: z.number(),
                dataTypeID: z.number(),
                dataTypeSize: z.number(),
                dataTypeModifier: z.number(),
                format: z.string(),
            })
        ).optional(),
        rows: z.array(z.any()),
        rowCount: z.number()
    }), "UXQueryResult"
);

@injectable()
@RoutePrefix("/apps/power")
@Security(AppSecurityPolicies.POWER)
@Tags("power")
export default class QueryController extends ApiHttpBaseController {
    public constructor(
        @inject(AppRequestScope.DATABASE)
        private readonly _db: IDatabase,
    ) {
        super();
    }

    @Post("/validate")
    @Summary("Validate an SQL query")
    @Consumes({
        "text": {
            schema: z.string()
        }
    })
    @Produces({
        "200": {
            description: "",
            content: {
                "text/plain": {}
            }
        }
    })
    @Throws({
        "access-denied": {
            description: "Found unauthorized reference(s) to external schema('s)."
        }
    })
    public async validateQuery(
        @Body()
            body: THttpRequestBody<"text">,
    ) {
        const sql = await body.text();
        const sqlSafe = this._validateSqlQueryText(sql);
        this.response.text(sqlSafe);
    }

    @Post("/query")
    @Summary("Execute an SQL query")
    @Consumes({
        "text": {
            schema: z.string()
        }
    })
    @Produces({
        "200": {
            description: "",
            content: {
                "application/json": {
                    schema: QueryResult
                }
            }
        }
    })
    @Throws({
        "access-denied": {
            description: "Found unauthorized reference(s) to external schema('s)."
        }
    })
    public async executeQuery(
        @Body()
            body: THttpRequestBody<"text">,

        @Optional()
        @Query("removeNulls")
            removeNulls: boolean = true,

        @Optional()
        @Query("returnInfo")
            returnInfo: boolean = false
    ) {
        const sql = await body.text();
        const sqlSafe = this._validateSqlQueryText(sql);
        let result: IQueryResult;
        if (!returnInfo) {
            const sqlResult = await this._db.manyOrNone(sqlSafe);
            result = { rowCount: sqlResult.length, rows: sqlResult };
        } else {
            const sqlResult = await this._db.result(sqlSafe);
            result = _.pick(sqlResult, ["command", "fields", "rowCount", "rows"]);
        }
        if (removeNulls) {
            for (const row of result.rows) {
                for (const key of Object.keys(row)) {
                    if (row[key] === null) delete row[key];
                }
            }
        }
        this.response.json(result);
    }

    @Post("/query-multi")
    @Summary("Execute multiple SQL queries and return results for each")
    @Consumes({
        "text": {
            schema: z.string()
        }
    })
    @Produces({
        "200": {
            description: "",
            content: {
                "application/json": {
                    schema: z.array(QueryResult)
                }
            }
        }
    })
    @Throws({
        "access-denied": {
            description: "Found unauthorized reference(s) to external schema('s)."
        }
    })
    public async executeQueryMulti(
        @Body()
            body: THttpRequestBody<"text">,

        @Optional()
        @Query("removeNulls")
            removeNulls: boolean = true,

        @Optional()
        @Query("returnInfo")
            returnInfo: boolean = false
    ) {
        const sql = await body.text();
        const sqlSafe = this._validateSqlQueryText(sql);
        let results: Array<IQueryResult>;
        if (!returnInfo) {
            const sqlResult = await this._db.multi(sqlSafe);
            results = sqlResult.map(r => ({ rowCount: r.length, rows: r }));
        } else {
            const sqlResults = await this._db.multiResult(sqlSafe);
            results = sqlResults.map(r => {
                return _.pick(r, ["command", "fields", "rowCount", "rows"]);
            });
        }
        if (removeNulls) {
            ObjectUtils.deepRemoveNullsInPlace(results);
        }
        this.response.json(results);
    }

    private _validateSqlQueryText(sql: string) {
        sql = SqlUtils.minify(sql);

        if (SqlUtils.findInQueryText(sql, SQL_SCHEMA_COMMANDS).length > 0) {
            throw new AccessDeniedError({
                message: "Unauthorized attempt to change database schema."
            });
        }
        return SqlUtils.replaceMultipleInQueryText(sql, [{
            pattern: SQL_SET_COMMAND,
            replacement: (_text, _scope, variable, value) => {
                if (variable && variable.toLowerCase() !== "search_path") {
                    throw new AccessDeniedError({
                        message: `Unauthorized SET command to: ${variable}`
                    });
                }
                if (!value || !value.includes(this._db.schema)) {
                    throw new AccessDeniedError({
                        message: "Unauthorized search_path schema reference found."
                    });
                }
                return "";
            }
        }, {
            pattern: SQL_TABLE_REFERENCE,
            replacement: (_text, preamble, schema, next) => {
                if (schema !== this._db.schema) {
                    throw new AccessDeniedError({
                        message: `Unauthorized table reference to external schema: ${schema}`
                    });
                }
                if (preamble.endsWith("\"") && next.startsWith("\"")) {
                    return preamble.slice(0, -1) + next.slice(2);
                } else {
                    return preamble + next.slice(1);
                }
            }
        }, {
            pattern: SQL_FUNCTION_CALL,
            replacement: (_text, schema, next) => {
                if (schema !== this._db.schema) {
                    throw new AccessDeniedError({
                        message: `Unauthorized function reference to external schema: ${schema}`
                    });
                }
                return next;
            }
        }], true);
    }
}
