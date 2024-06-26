&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOPM249
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName acidte_trab
&GLOBAL-DEFINE TableLabel Acidente
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cstp/st/api/v1/services/bopm249.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable iDay   as integer no-undo.
define variable iMonth as integer no-undo.
define variable iYear  as integer no-undo.
define variable dDate  as date    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.54
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn_empresa":U THEN ASSIGN pFieldValue = RowObject.cdn_empresa.
        WHEN "cdn_empres_analis_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_analis_acidtrab.
        WHEN "cdn_empres_mandat_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_mandat_cipa.
        WHEN "cdn_empres_presid_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_presid_cipa.
        WHEN "cdn_empres_respons_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_respons_cipa.
        WHEN "cdn_empres_respons_depto":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_respons_depto.
        WHEN "cdn_empres_respons_inform":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_respons_inform.
        WHEN "cdn_empres_secretar_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_empres_secretar_cipa.
        WHEN "cdn_estab":U THEN ASSIGN pFieldValue = RowObject.cdn_estab.
        WHEN "cdn_estab_analis_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_analis_acidtrab.
        WHEN "cdn_estab_mandat_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_mandat_cipa.
        WHEN "cdn_estab_presid_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_presid_cipa.
        WHEN "cdn_estab_respons_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_respons_cipa.
        WHEN "cdn_estab_respons_depto":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_respons_depto.
        WHEN "cdn_estab_respons_inform":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_respons_inform.
        WHEN "cdn_estab_secretar_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_estab_secretar_cipa.
        WHEN "cod_abrangen_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.cod_abrangen_acidte_trab.
        WHEN "cod_agent_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cod_agent_acidtrab.
        WHEN "cod_agent_risco":U THEN ASSIGN pFieldValue = RowObject.cod_agent_risco.
        WHEN "cod_area_segur":U THEN ASSIGN pFieldValue = RowObject.cod_area_segur.
        WHEN "cod_area_segur_investig_cipa":U THEN ASSIGN pFieldValue = RowObject.cod_area_segur_investig_cipa.
        WHEN "cod_area_segur_parecer_cipa":U THEN ASSIGN pFieldValue = RowObject.cod_area_segur_parecer_cipa.
        WHEN "cod_clien_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.cod_clien_acidte_trab.
        WHEN "cod_fonte_gerador_risco":U THEN ASSIGN pFieldValue = RowObject.cod_fonte_gerador_risco.
        WHEN "cod_fonte_gerad_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.cod_fonte_gerad_acidte_trab.
        WHEN "cod_grp_mail":U THEN ASSIGN pFieldValue = RowObject.cod_grp_mail.
        WHEN "cod_ipcto_ambntal":U THEN ASSIGN pFieldValue = RowObject.cod_ipcto_ambntal.
        WHEN "cod_livre_1":U THEN ASSIGN pFieldValue = RowObject.cod_livre_1.
        WHEN "cod_livre_2":U THEN ASSIGN pFieldValue = RowObject.cod_livre_2.
        WHEN "cod_local_empres":U THEN ASSIGN pFieldValue = RowObject.cod_local_empres.
        WHEN "cod_norma_segur":U THEN ASSIGN pFieldValue = RowObject.cod_norma_segur.
        WHEN "cod_obj_gerador_acidte":U THEN ASSIGN pFieldValue = RowObject.cod_obj_gerador_acidte.
        WHEN "cod_orig_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.cod_orig_acidte_trab.
        WHEN "cod_produt_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.cod_produt_acidte_trab.
        WHEN "cod_rh_ccusto":U THEN ASSIGN pFieldValue = RowObject.cod_rh_ccusto.
        WHEN "cod_sist_qualid_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.cod_sist_qualid_acidte_trab.
        WHEN "cod_tag":U THEN ASSIGN pFieldValue = RowObject.cod_tag.
        WHEN "cod_tip_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cod_tip_acidtrab.
        WHEN "cod_unid_federac":U THEN ASSIGN pFieldValue = RowObject.cod_unid_federac.
        WHEN "cod_unid_lotac":U THEN ASSIGN pFieldValue = RowObject.cod_unid_lotac.
        WHEN "cod_usuar_ult_atualiz":U THEN ASSIGN pFieldValue = RowObject.cod_usuar_ult_atualiz.
        WHEN "des_cancel_acidtrab":U THEN ASSIGN pFieldValue = RowObject.des_cancel_acidtrab.
        WHEN "des_causa_acidte_cipa":U THEN ASSIGN pFieldValue = RowObject.des_causa_acidte_cipa.
        WHEN "des_cidad_acidte":U THEN ASSIGN pFieldValue = RowObject.des_cidad_acidte.
        WHEN "des_conclus_acidte_trab_cipa":U THEN ASSIGN pFieldValue = RowObject.des_conclus_acidte_trab_cipa.
        WHEN "des_investig_acidtrab":U THEN ASSIGN pFieldValue = RowObject.des_investig_acidtrab.
        WHEN "des_local_acidtrab":U THEN ASSIGN pFieldValue = RowObject.des_local_acidtrab.
        WHEN "des_lote_produt":U THEN ASSIGN pFieldValue = RowObject.des_lote_produt.
        WHEN "des_parecer_func_respons":U THEN ASSIGN pFieldValue = RowObject.des_parecer_func_respons.
        WHEN "des_resum_acidtrab":U THEN ASSIGN pFieldValue = RowObject.des_resum_acidtrab.
        WHEN "dsl_analis_acidtrab":U THEN ASSIGN pFieldValue = RowObject.dsl_analis_acidtrab.
        WHEN "hra_acidtrab":U THEN ASSIGN pFieldValue = RowObject.hra_acidtrab.
        WHEN "hra_ult_atualiz":U THEN ASSIGN pFieldValue = RowObject.hra_ult_atualiz.
        WHEN "nom_contat_acidtrab":U THEN ASSIGN pFieldValue = RowObject.nom_contat_acidtrab.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat_acidtrab":U THEN ASSIGN pFieldValue = RowObject.dat_acidtrab.
        WHEN "dat_analis_acidtrab":U THEN ASSIGN pFieldValue = RowObject.dat_analis_acidtrab.
        WHEN "dat_atendim":U THEN ASSIGN pFieldValue = RowObject.dat_atendim.
        WHEN "dat_cancel_acidtrab":U THEN ASSIGN pFieldValue = RowObject.dat_cancel_acidtrab.
        WHEN "dat_livre_1":U THEN ASSIGN pFieldValue = RowObject.dat_livre_1.
        WHEN "dat_livre_2":U THEN ASSIGN pFieldValue = RowObject.dat_livre_2.
        WHEN "dat_ult_atualiz":U THEN ASSIGN pFieldValue = RowObject.dat_ult_atualiz.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdd_telef_contat_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cdd_telef_contat_acidtrab.
        WHEN "val_cgc_empres_acidte":U THEN ASSIGN pFieldValue = RowObject.val_cgc_empres_acidte.
        WHEN "val_despes_calcul_acidtrab":U THEN ASSIGN pFieldValue = RowObject.val_despes_calcul_acidtrab.
        WHEN "val_livre_1":U THEN ASSIGN pFieldValue = RowObject.val_livre_1.
        WHEN "val_livre_2":U THEN ASSIGN pFieldValue = RowObject.val_livre_2.
        WHEN "val_telef_contat_acidtrab":U THEN ASSIGN pFieldValue = RowObject.val_telef_contat_acidtrab.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn_fornec_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cdn_fornec_acidtrab.
        WHEN "cdn_func_analis_acidtrab":U THEN ASSIGN pFieldValue = RowObject.cdn_func_analis_acidtrab.
        WHEN "cdn_func_respons_depto":U THEN ASSIGN pFieldValue = RowObject.cdn_func_respons_depto.
        WHEN "cdn_func_respons_inform":U THEN ASSIGN pFieldValue = RowObject.cdn_func_respons_inform.
        WHEN "cdn_plano_lotac":U THEN ASSIGN pFieldValue = RowObject.cdn_plano_lotac.
        WHEN "cdn_presid_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_presid_cipa.
        WHEN "cdn_respons_cipa_investig":U THEN ASSIGN pFieldValue = RowObject.cdn_respons_cipa_investig.
        WHEN "cdn_secretar_cipa":U THEN ASSIGN pFieldValue = RowObject.cdn_secretar_cipa.
        WHEN "cdn_turno_trab":U THEN ASSIGN pFieldValue = RowObject.cdn_turno_trab.
        WHEN "idi_gravid_acidtrab":U THEN ASSIGN pFieldValue = RowObject.idi_gravid_acidtrab.
        WHEN "idi_local_acidte_trab":U THEN ASSIGN pFieldValue = RowObject.idi_local_acidte_trab.
        WHEN "idi_tip_acidtrab":U THEN ASSIGN pFieldValue = RowObject.idi_tip_acidtrab.
        WHEN "idi_tip_ocor_acidtrab":U THEN ASSIGN pFieldValue = RowObject.idi_tip_ocor_acidtrab.
        WHEN "num_acidtrab":U THEN ASSIGN pFieldValue = RowObject.num_acidtrab.
        WHEN "num_ambien_risco":U THEN ASSIGN pFieldValue = RowObject.num_ambien_risco.
        WHEN "num_cgc_empres_acidte":U THEN ASSIGN pFieldValue = RowObject.num_cgc_empres_acidte.
        WHEN "num_compon_sesmt_respons":U THEN ASSIGN pFieldValue = RowObject.num_compon_sesmt_respons.
        WHEN "num_livre_1":U THEN ASSIGN pFieldValue = RowObject.num_livre_1.
        WHEN "num_livre_2":U THEN ASSIGN pFieldValue = RowObject.num_livre_2.
        WHEN "num_mandat_cipa":U THEN ASSIGN pFieldValue = RowObject.num_mandat_cipa.
        WHEN "num_respons_mandat_cipa":U THEN ASSIGN pFieldValue = RowObject.num_respons_mandat_cipa.
        WHEN "num_riscacid":U THEN ASSIGN pFieldValue = RowObject.num_riscacid.
        WHEN "num_seq_mapa_risco":U THEN ASSIGN pFieldValue = RowObject.num_seq_mapa_risco.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice acdttrb_id
  Parameters:  
               retorna valor do campo cdn_empresa
               retorna valor do campo cdn_estab
               retorna valor do campo num_acidtrab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn_empresa LIKE acidte_trab.cdn_empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn_estab LIKE acidte_trab.cdn_estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum_acidtrab LIKE acidte_trab.num_acidtrab NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn_empresa = RowObject.cdn_empresa
           pcdn_estab = RowObject.cdn_estab
           pnum_acidtrab = RowObject.num_acidtrab.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log_bloq_acidtrab":U THEN ASSIGN pFieldValue = RowObject.log_bloq_acidtrab.
        WHEN "log_control_inspec_risco":U THEN ASSIGN pFieldValue = RowObject.log_control_inspec_risco.
        WHEN "log_existe_mapa_risco":U THEN ASSIGN pFieldValue = RowObject.log_existe_mapa_risco.
        WHEN "log_existe_ppra":U THEN ASSIGN pFieldValue = RowObject.log_existe_ppra.
        WHEN "log_ident_risco_laudo":U THEN ASSIGN pFieldValue = RowObject.log_ident_risco_laudo.
        WHEN "log_inspec_realzdo_eqpcol":U THEN ASSIGN pFieldValue = RowObject.log_inspec_realzdo_eqpcol.
        WHEN "log_livre_1":U THEN ASSIGN pFieldValue = RowObject.log_livre_1.
        WHEN "log_livre_2":U THEN ASSIGN pFieldValue = RowObject.log_livre_2.
        WHEN "log_quest_acidtrab":U THEN ASSIGN pFieldValue = RowObject.log_quest_acidtrab.
        WHEN "log_reg_polic":U THEN ASSIGN pFieldValue = RowObject.log_reg_polic.
        WHEN "log_risco_norma_segur":U THEN ASSIGN pFieldValue = RowObject.log_risco_norma_segur.
        WHEN "log_vitima_acidtrab":U THEN ASSIGN pFieldValue = RowObject.log_vitima_acidtrab.
        WHEN "log_vitima_fatal":U THEN ASSIGN pFieldValue = RowObject.log_vitima_fatal.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice acdttrb_id
  Parameters:  
               recebe valor do campo cdn_empresa
               recebe valor do campo cdn_estab
               recebe valor do campo num_acidtrab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn_empresa LIKE acidte_trab.cdn_empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcdn_estab LIKE acidte_trab.cdn_estab NO-UNDO.
    DEFINE INPUT PARAMETER pnum_acidtrab LIKE acidte_trab.num_acidtrab NO-UNDO.

    FIND FIRST bfacidte_trab WHERE 
        bfacidte_trab.cdn_empresa = pcdn_empresa AND 
        bfacidte_trab.cdn_estab = pcdn_estab AND 
        bfacidte_trab.num_acidtrab = pnum_acidtrab NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfacidte_trab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfacidte_trab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDayMonthYear DBOProgram 
PROCEDURE openQueryDayMonthYear :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName}
    no-lock
    where day({&TableName}.dat_acidtrab) = iDay
    and month({&TableName}.dat_acidtrab) = iMonth
    and year ({&TableName}.dat_acidtrab) = iYear.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonthYear DBOProgram 
PROCEDURE openQueryMonthYear :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName}
    no-lock
    where month({&TableName}.dat_acidtrab) = iMonth
    and   year({&TableName}.dat_acidtrab)  = iYear.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDayMonthYear DBOProgram 
PROCEDURE setConstraintDayMonthYear :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pDay   as integer no-undo.
    define input parameter pMonth as integer no-undo.
    define input parameter pYear  as integer no-undo.
    
    assign 
        iDay   = pDay
        iMonth = pMonth
        iYear  = pYear.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonthYear DBOProgram 
PROCEDURE setConstraintMonthYear :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pMonth as integer no-undo.
    define input parameter pYear  as integer no-undo.
    
    assign 
        iMonth = pMonth
        iYear  = pYear.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

