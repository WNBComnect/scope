/*************************************************
 Copyright (c) 2008, Itautec
 -------------------------------------------------
 Project  : Dll ScopeApi
 Module   : 
 File     : Rede.h
 Ver      : p1.00
 Date     : 16/11/98
 Compiler :	Visual C/C++ 5.0
 Env.     :
 Descrip. : Rede of Service Defines (same value of Database)
 -------------------------------------------------
 Revision History:
 *************************************************/

/*------------------------------------------------------------------*/
/* Atencao !!! :   Este modulo deve ser compativel com UNIX         */
/*------------------------------------------------------------------*/

#ifndef		_REDE
#define		_REDE			1

typedef enum {
/*00*/	R_SCOPE,
/*01*/	R_TECBAN,
/*02*/	R_ITAU,
/*03*/	R_VISANET,
/*04*/	R_BRADESCO,
/*05*/	R_REDECARD,
/*06*/	R_FININVEST,
/*07*/	R_SERASA,
/*08*/	R_TELEDATA,
/*09*/	R_BANRISUL,
/*10*/	R_TICKET,
/*11*/	R_ACSP,
/*12*/	R_BRASILCARD,
/*13*/	R_SYSDATA,
/*14*/	R_REDECARD_L0102,
/*15*/	R_VISANET_199810,
/*16*/	R_CBD,
/*17*/	R_LOJISTA,
/*18*/	R_CSU,
/*19*/	R_SENFF,
/*20*/	R_BEM,
/*21*/	R_TOKORO,
/*22*/	R_MAXICRED,
/*23*/	R_ZOGBI,
/*24*/	R_ACC_CARD,
/*25*/	R_SOROCRED,
/*26*/	R_COOPERCRED,
/*27*/	R_TELESP,
/*28*/	R_POLICARD,
/*29*/	R_VIAVAREJO,
/*30*/	R_SAB,
/*31*/	R_EPHARMA,
/*32*/	R_VIDALINK,
/*33*/	R_PREVSAUDE,
/*34*/	R_HIPERCARD,
/*35*/	R_INTERCHANGE,
/*36*/	R_TECBAN_20,
/*37*/	R_NUTRICASH,
/*38*/	R_LOSANGO,
/*39*/	R_GOODCARD,
/*40*/	R_CETELEM,
/*41*/	R_BONUS,
/*42*/	R_AMEX,
/*43*/	R_BBGCB,
/*44*/	R_SONAE,
/*45*/  R_INCOMM,
/*46*/	R_PORTALCARD,
/*47*/	R_VALECARD,
/*48*/	R_TELENET,
/*49*/	R_EVANGELICO,
/*50*/	R_FUNCIONALCARD,
/*51*/	R_EDIGUAY,
/*52*/	R_CHECKCHECK,
/*53*/	R_BANKTEC,
/*54*/	R_BIG,
/*55*/	R_BIGCARD,
/*56*/	R_SUPERCARD,
/*57*/	R_BANESE,
/*58*/	R_TRCENTRE,
/*59*/	R_TRNCARD,
/*60*/	R_INFOCARDS,
/*61*/	R_VALECASH,
/*62*/	R_PREMIUM,
/*63*/	R_CREDSYSTEM,
/*64*/	R_REDECARD_L0205,
/*65*/	R_ECAPTURE,
/*66*/	R_CHECKEXPRESS,
/*67*/	R_CONDUCTOR,
/*68*/	R_CHEQUEPRE,
/*69*/	R_VISANET_41,
/*70*/	R_AMEX_03,
/*71*/	R_ECXCARD,
/*72*/	R_ULTRAGAZ,
/*73*/  R_GETNET,
/*74*/	R_CENTRALCARD,
/*75*/	R_ORBITALL,	
/*76*/	R_RECCEL,	
/*77*/	R_IBI,		
/*78*/  R_DATASUS,
/*79*/  R_COMPROCARD,
/*80*/  R_FARMASEG,
/*81*/  INTELLISYS,
/*82*/  R_SOMAR,
/*83*/  R_SOLUCARD,
/*84*/  R_OBOE,
/*85*/  R_DACASA,
/*86*/  R_VALESHOP,
/*87*/  R_FIDELIZE,
/*88*/	R_UTILCARD,
/*89*/	R_RVTEC,
/*90*/  R_GWCEL,
/*91*/  R_UPAID,
/*92*/  R_REDECARD_L0401,
/*93*/  R_BANPARA,
/*94*/  R_NEUS,
/*95*/  R_CREDISHOP,
/*96*/	R_HSBC,
/*97*/	R_ISOGCB,
/*98*/  R_PHARMASYSTEM,
/*99*/  R_BANRISUL_EMV,
/*100*/ R_BANESTES,
/*101*/ R_FANCARDS,
/*102*/ R_CIELO,
/*103*/ R_REDECARD_L0500,
/*104*/ R_DIAMANTE,
/*105*/ R_SOFTNEX,
/*106*/ R_LOJISTA_V0205,
/*107*/ R_TIVIT,
/*108*/ R_GETNETLAC,
/*109*/ R_USECRED,
/*110*/ R_XHC,
/*111*/ R_G_CARD,
/*112*/ R_DMCARD,
/*113*/ R_SISCRED,
/*114*/ R_EPAY,
/*115*/ 
/*116*/ R_ORGCARD = 116,
/*117*/ R_SAVS, 
/*118*/ R_TENDENCIA = 118,
/*119*/ R_LEADER,
/*120*/ R_BLACKHAWK,
/*121*/ R_RVTECNOLOGIA,
/*122*/ R_ITAU_MOBILE,
/*123*/ R_GIVEX,
/*124*/ R_CREDITEM,
/*125*/ R_FOXWIN,
/*126*/ R_FIRSTDATA,
/*127*/ R_TOPCARD = 127,
/*128*/ R_ELAVON,
/*129*/ R_VR,
/*130*/ R_BANESTIK,
/*132*/ R_AVISTA = 132,
/*133*/ R_PBMPADRAO = 133,
/*134*/ R_CONDUCTOR_PL = 134,

	/* /\ inserir próxima rede na linha acima /\ */

		R_NUM_MAXIMO = 255
}	eRede;

#define R_BANKBOSTON 45 // para manter compatibilidade com versoes antigas
#define R_CNS 12 // para manter compatibilidade com versoes antigas

#define SCOPEMOBILE_HEADER "SCOPEMOBILE"
#define SCOPEMOBILE_VERSAO "0100"

typedef enum 
{
ESPEC_GWCEL_V003 = 1,
ESPEC_GWCEL_V005 = 2
}	eVersaoEspecGwCel;

typedef enum 
{
ESPEC_REC_SCOPE_0100 = 1,	
ESPEC_REC_SCOPE_0200 = 2 
}	eVersaoEspecRecargaPadraoSCOPE;

typedef enum 
{
ESPEC_GETNET_0100 = 1,	
ESPEC_GETNET_0200 = 2 
}	eVersaoEspecGetNet;

typedef enum 
{
ESPEC_REDECARD_V0500 = 1,	
ESPEC_REDECARD_V0501 = 2, 
ESPEC_REDECARD_V0502 = 3 
}	eVersaoEspecRedeCard;

typedef enum 
{
ESPEC_IBI_V0100 = 1,	
ESPEC_IBI_XSAB128a = 2 
}	eVersaoEspecIBI;

#endif

