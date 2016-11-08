!
! COPYRIGHT (C) 1991 - 2016  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
! -------------------------------------------------------------------------
! sd_nl data structure : Parameters <-> integer definitions
! -------------------------------------------------------------------------
!
#define _NL_NBPAR 90

#define _ADHERANCE 1
#define _ANTISISMIC_C 2
#define _ANTISISMIC_DX_MAX 3
#define _ANTISISMIC_K1 4
#define _ANTISISMIC_K2 5
#define _ANTISISMIC_PUIS_ALPHA 6
#define _ANTISISMIC_SEUIL_FX 7
#define _BUCKLING_LIMIT_FORCE 8
#define _BUCKLING_POST_PALIER_FORCE 9
#define _BUCKLING_POST_STIFFNESS 10
#define _COOR_NO1 11
#define _COOR_NO2 12
#define _COOR_ORIGIN_OBSTACLE 13
#define _COOR_PRE_STICK 14
#define _DAMP_NORMAL 15
#define _DAMP_TANGENTIAL 16
#define _DISC_ISOT_DX 17
#define _DISC_ISOT_DX0 18
#define _DIST_NO1 19
#define _DIST_NO2 20
#define _DISVISC_A 21
#define _DISVISC_C 22
#define _DISVISC_K1 23
#define _DISVISC_K2 24
#define _DISVISC_K3 25
#define _DT_EDYOS 26
#define _FRIC_DYNAMIC 27
#define _FRIC_STATIC 28
#define _FV_DEPLR 29
#define _FV_FONCT 30
#define _FV_SREVI 31
#define _FV_SREVR 32
#define _FX_DEPLR 33
#define _FX_FONCT 34
#define _FX_SREDI 35
#define _FX_SREDR 36
#define _MAX_INTE 37
#define _MESH_1 38
#define _MESH_2 39
#define _MODAL_DEPL_NO1 40
#define _MODAL_DEPL_NO2 41
#define _NB_ANTSI 42
#define _NB_CHOC 43
#define _NB_DIS_ECRO_TRAC 44
#define _NB_DIS_VISC 45
#define _NB_FLAMB 46
#define _NB_PALIE 47
#define _NB_REL_FV  48
#define _NB_REL_FX  49
#define _NB_R_FIS  50
#define _NL_FUNC_DEF  51
#define _NL_TITLE  52
#define _NL_TYPE  53
#define _NO1_NAME  54
#define _NO2_NAME  55
#define _NORMAL_VECTOR  56
#define _NUMDDL_1  57
#define _NUMDDL_2  58
#define _OBST_TYP  59
#define _PAL_CN  60
#define _PAL_FIN  61
#define _PAL_FSAV  62
#define _PAL_NBCV  63
#define _PAL_TYP  64
#define _GAP  65
#define _PSI_DELT_NO1  66
#define _REST_RATIO  67
#define _RES_INTE  68
#define _RIGI_TANGENTIAL  69
#define _ROTR_DFK  70
#define _ROTR_FK  71
#define _SIGN_DYZ  72
#define _SINCOS_ANGLE_A  73
#define _SINCOS_ANGLE_B  74
#define _SINCOS_ANGLE_G  75
#define _SS1_NAME  76
#define _SS2_NAME  77
#define _STIF_NORMAL  78
#define _TANGENTIAL_FORCE_PRE_STICK  79
#define _TANGENTIAL_VELOCITY_PREVIOUS_STEP  80
#define _INTERNAL_VARS  81
#define _MAX_LEVEL  82
#define _F_TOT_WK  83
#define _F_TAN_WK  84
#define _CMP_NAME  85
#define _PSI_DELT_NO2  86
#define _ANG_INIT  87
#define _ANG_ROTA  88
#define _INTERNAL_VARS_INDEX  89
#define _FRIC_UNIDIR  90

#define _NL_NB_TYPES     9

#define NL_CHOC            1
#define NL_BUCKLING        2
#define NL_ANTI_SISMIC     3
#define NL_DIS_VISC        4
#define NL_DIS_ECRO_TRAC   5
#define NL_CRACKED_ROTOR   6
#define NL_LUBRICATION     7
#define NL_FX_RELATIONSHIP 8
#define NL_FV_RELATIONSHIP 9


#define NBVARINT_CHOC 20
#define NBVARINT_FLAM 9
#define NBVARINT_ANTS 8
#define NBVARINT_DVIS 11
#define NBVARINT_DECR 12
#define NBVARINT_ROTF 3
#define NBVARINT_YACS 0
#define NBVARINT_FXRL 3
#define NBVARINT_FVRL 3
