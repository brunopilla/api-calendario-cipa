using Progress.Json.ObjectModel.*.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using progress.Lang.error.
using com.totvs.framework.api.*.

{utp/ut-api.i}
{utp/ut-api-action.i pi-list get /~* }
{cstp/st/api/v1/services/environments.i}
{utp/ut-api-notfound.i}
{method/dbotterr.i}
{cstp/st/api/v1/services/bopm249.i ttAcidente}

define variable boHandler as handle no-undo.


/*****************************************************************************
                             LISTAR ACIDENTES 
******************************************************************************/
procedure pi-list:
    
    define input  param oReq      as JsonObject           no-undo.
    define output param oRes      as JsonObject           no-undo.
    define variable aJsonArray    as JsonArray            no-undo.
    define variable aJsonArrayRes as JsonArray            no-undo.
    define variable rId           as rowid                no-undo.
    define variable iReturnedRows as integer              no-undo.
    define variable iStartRow     as integer              no-undo.
    define variable iPageSize     as integer              no-undo.
    define variable iPage         as integer              no-undo.    
    define variable oRequest      as JsonAPIRequestParser no-undo.
    define variable iContIni      as integer              no-undo.
    define variable iContFin      as integer              no-undo.
    define variable hasNext       as logical initial true no-undo.
    define variable hasFirst      as logical initial true no-undo.
    define variable oQueryParams  as JsonObject           no-undo.
    define variable oJsonObject   as JsonObject           no-undo.
    define variable i             as integer              no-undo.
    define variable msg           as JsonObject           no-undo.
    define variable msgArray      as JsonArray            no-undo.
    define variable iDay          as integer              no-undo.
    define variable iMonth        as integer              no-undo.
    define variable iYear         as integer              no-undo.
    
    assign
        orequest      = new JsonAPIRequestParser(oReq)
        oQueryParams  = new JsonObject()
        aJsonArray    = new JsonArray()
        aJsonArrayRes = new JsonArray()
        oQueryParams  = oReq:getJsonObject("queryParams")
        iStartRow     = oRequest:getStartRow()
        iPageSize     = oRequest:getPageSize()
        iPage         = oRequest:getPage().
        
    if not valid-handle(boHandler) then do:

        run {&prefix}services/bopm249.p persistent set boHandler.       
    end.
    
    if oQueryParams:has("day") and oQueryParams:has("month") and oQueryParams:has("year") then do:
        assign 
            iDay   = integer(oQueryParams:GetJsonArray("day"):getJsonText(1))
            iMonth = integer(oQueryParams:GetJsonArray("month"):getJsonText(1))
            iYear  = integer(oQueryParams:GetJsonArray("year"):getJsonText(1)).

        run setConstraintDayMonthYear in boHandler (input iDay, input iMonth, input iYear).
        run openQueryStatic        in boHandler (input "DayMonthYear":U).
        run emptyRowErrors         in boHandler.
        run getFirst               in boHandler.
    end.
    else if oQueryParams:has("month") and oQueryParams:has("year") then do:
        assign 
            iMonth = integer(oQueryParams:GetJsonArray("month"):getJsonText(1))
            iYear  = integer(oQueryParams:GetJsonArray("year"):getJsonText(1)).

        run setConstraintMonthYear in boHandler (input iMonth, input iYear).
        run openQueryStatic        in boHandler (input "MonthYear":U).
        run emptyRowErrors         in boHandler.
        run getFirst               in boHandler.
    end.
    else do:
        run setConstraintMain in boHandler.
        run openQueryStatic   in boHandler (input "Main":U).
        run emptyRowErrors    in boHandler.
        run getFirst          in boHandler.
    end.
    
    if return-value = "NOK" then do:

        aJsonArray = new JsonArray().
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, false).
        
        if valid-handle(boHandler) then
            run destroy in boHandler.
        return.
    end.

    if iStartRow > 1 then do:
        assign iContFin = iStartRow - 1.
        do iContIni = 1 to iContFin:
            run getNext in boHandler.
            if return-value = "NOK":U then do:
                run emptyRowErrors in boHandler.
                assign hasNext  = false.
                if  iStartRow > iContIni then
                    assign hasFirst = false.
                leave.
            end.
        end.
    end.
    
    if hasFirst then do:
        run getRowid in boHandler (output rId).
        run getBatchRecords in boHandler( 
            input  rId, //parƒmetro de entrada, que indica o rowid a ser reposicionado para o in¡cio da leitura
            input  no, //parƒmetro de entrada, que indica se a leitura deve ser feita a partir do pr¢ximo registro
            input  iPageSize, //parƒmetro de entrada, que indica o n£mero de registros a serem retornados;
            output iReturnedRows, //parƒmetro de sa¡da, que indica o n£mero de registros retornados
            output table ttAcidente //parƒmetro de entrada, que cont‚m o handle da temp-table onde serÆo retornados os registros
        ).
        if iReturnedRows < iPageSize then do:
            assign hasNext = false.
        end.
        else do:
            run getFirst in boHandler.
            do iContIni = 1 to (iPage * ipageSize):
                run getNext in boHandler.
                if return-value = "NOK":U then do:
                    run emptyRowErrors in boHandler.
                    assign hasNext = false.
                    leave.
                end.
            end.
        end.
    end.
   
    run getRowErrors in boHandler (output table RowErrors append).
    
    if can-find(first RowErrors where upper(RowErrors.ErrorSubType) = 'ERROR':U) then do:
        assign oRes = JsonApiResponseBuilder:asError(temp-table RowErrors:handle).
    end.
    else do:

        assign
            aJsonArray = JsonAPIUtils:ConvertTempTableToJsonArray(temp-table ttAcidente:handle).
            aJsonArrayRes = new jsonArray().

        do i = 1 to iReturnedRows:

            oJsonObject = new jsonObject().
            oJsonObject = aJsonArray:getJsonObject(i).
                    
            if(oJsonObject:getinteger('idi_tip_ocor_acidtrab')) = 1 then
                oJsonObject:add('tipo', 'Acidente no Trabalho').
            else if(oJsonObject:getinteger('idi_tip_ocor_acidtrab')) = 2 then
                oJsonObject:add('tipo', 'Acidente Trajeto').
            else if(oJsonObject:getinteger('idi_tip_ocor_acidtrab')) = 3 then
                oJsonObject:add('tipo', 'Doen‡a Trabalho').
            else if(oJsonObject:getinteger('idi_tip_ocor_acidtrab')) = 4 then
                oJsonObject:add('tipo', 'Quase Acidente no Trabalho').
            else if(oJsonObject:getinteger('idi_tip_ocor_acidtrab')) = 5 then
                oJsonObject:add('tipo', 'Acidente em Percurso Interno').
            else if(oJsonObject:getinteger('idi_tip_ocor_acidtrab')) = 6 then
                oJsonObject:add('tipo', 'Quase Acidente em Percurso Interno').

            oJsonObject:add('dia', day(oJsonObject:getdate('dat_acidtrab'))).
            oJsonObject:add('hora', string(oJsonObject:getcharacter('hra_acidtrab'),"99:99")).
            aJsonArrayRes:add(oJsonObject).
        end.

        assign aJsonArray = aJsonArrayRes.
        assign oRes = JsonApiResponseBuilder:ok(aJsonArray, hasNext).
        if valid-handle(boHandler) then
            run destroy in boHandler.
    end.

    catch oE as error:
        assign oRes = JsonApiResponseBuilder:asError(oE).
    end catch. 
    
    finally: delete procedure boHandler no-error. end finally. 

end procedure.

