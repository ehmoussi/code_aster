! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! aslint: disable=W1501,W1504,W1502
! person_in_charge: sylvie.granet at edf.fr
!
subroutine thmrcp(etape, imate, thmc, hydr,&
                  ther, t, p1, p1m, p2,&
                  phi, pvp, rgaz, rhod,&
                  cpd, satm, satur, dsatur,&
                  permli, dperml, permgz,&
                  dperms, dpermp, fick, dfickt, dfickg,&
                  lambp, dlambp, rhol, unsurk, alpha,&
                  cpl, lambs, dlambs, viscl, dviscl,&
                  mamolg, cpg, tlambt, tdlamt, viscg,&
                  dviscg, mamolv, cpvg, viscvg, dvisvg,&
                  fickad, dfadt, cpad, kh, pad,&
                  em, tlamct, retcom,&
                  angmas, ndim)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/tdlamb.h"
#include "asterfort/telamb.h"
#include "asterfort/tlambc.h"
#include "asterfort/utmess.h"
#include "asterfort/thmEvalSatuMiddle.h"
#include "asterfort/thmEvalSatuFinal.h"
#include "asterfort/thmEvalPermLiquGaz.h"
#include "asterfort/thmEvalFickSteam.h"
#include "asterfort/thmEvalFickAir.h"
    integer :: imate, retcom, ndim
    integer :: aniso2, aniso3, aniso4
    real(kind=8) :: t, p1, p2, phi, pvp
    real(kind=8) :: rgaz, rhod, cpd, satm, satur, dsatur
    real(kind=8) :: permli, dperml, permgz, dperms, dpermp
    real(kind=8) :: fick, dfickt, dfickg, lambp, dlambp, rhol
    real(kind=8) :: alpha, cpl, lambs, dlambs, viscl, dviscl, cpg, pad
    real(kind=8) :: viscg, dviscg, mamolg, cpvg, viscvg
    real(kind=8) :: dvisvg, fickad, dfadt, mamolv, p1m, cpad, kh, em
    real(kind=8) :: unsurk
    real(kind=8) :: angmas(3)
    real(kind=8) :: lambct(4), tlamct(ndim, ndim)
    real(kind=8) :: lambt(4), tlambt(ndim, ndim)
    real(kind=8) :: dlambt(4), tdlamt(ndim, ndim)
    character(len=8) :: etape
    character(len=16) :: thmc, ther, hydr
! =====================================================================
! --- VARIABLES LOCALES -----------------------------------------------
! =====================================================================
    integer :: ii
    integer :: dim18, dim19, dim20, dim21, dim22
    integer :: dim23, dim24, dim25, dim26, dim27, dim28, dim29
    integer :: dim30, dim31, dim32, dim33
    integer :: dimpar
    integer :: dim40, dim41, dim42, dim43
    parameter   ( dim18  = 22 )
    parameter   ( dim19  =  4 )
    parameter   ( dim20  = 23 )
    parameter   ( dim21  =  3 )
    parameter   ( dim22  = 32 )
    parameter   ( dim23  =  4 )
    parameter   ( dim24  =  3 )
    parameter   ( dim25  = 38 )
    parameter   ( dim26  =  4 )
    parameter   ( dim27  =  3 )
    parameter   ( dim28  =  1 )
    parameter   ( dim29  = 32 )
    parameter   ( dim30  =  4 )
    parameter   ( dim31  =  3 )
    parameter   ( dim32  = 28 )
    parameter   ( dim33  =  4 )
    parameter   ( dim40  = 43 )
    parameter   ( dim41  =  4 )
    parameter   ( dim42  =  3 )
    parameter   ( dim43  =  1 )
!
    parameter   ( dimpar  =  4 )
!
!   NRESMA EST LE MAX DE DIMPAR, DIMSAT ET DE DIMI, AVEC I DE 1 A 43
    integer, parameter :: nresma = 40
!
    real(kind=8) :: val18(dim18), val19(dim19), val20(dim20)
    real(kind=8) :: val21(dim21), val22(dim22), val23(dim23)
    real(kind=8) :: val24(dim24), val25(dim25), val26(dim26)
    real(kind=8) :: val27(dim27), val28(dim28), val29(dim29)
    real(kind=8) :: val30(dim30), val31(dim31), val32(dim32)
    real(kind=8) :: val33(dim33)
    real(kind=8) :: val40(dim40), val41(dim41), val42(dim42), val43(dim43)
    real(kind=8) :: valpar(dimpar)
    real(kind=8) :: un, zero
!
!
    integer :: icodre(nresma)
    character(len=4) :: nompar(dimpar)
    character(len=16) :: ncra18(dim18), ncra19(dim19), ncra20(dim20)
    character(len=16) :: ncra21(dim21), ncra22(dim22), ncra23(dim23)
    character(len=16) :: ncra24(dim24), ncra25(dim25), ncra26(dim26)
    character(len=16) :: ncra27(dim27), ncra28(dim28), ncra29(dim29)
    character(len=16) :: ncra30(dim30), ncra31(dim31), ncra32(dim32)
    character(len=16) :: ncra33(dim33)
    character(len=16) :: ncra40(dim40)
    character(len=16) :: ncra41(dim41), ncra42(dim42), ncra43(dim43)
    character(len=16) :: crad40(dim40)
    character(len=16) :: crad41(dim41), crad42(dim42)
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_SATU ------------
! =====================================================================
    data ncra18 / 'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO' ,&
     &              'LAMB_T'   ,&
     &              'LAMB_TL'   ,&
     &              'LAMB_TN'   ,&
     &              'D_LB_T',&
     &              'D_LB_TL',&
     &              'D_LB_TN',&
     &              'LAMB_PHI'   ,&
     &              'D_LB_PHI',&
     &              'LAMB_CT',&
     &              'LAMB_C_L',&
     &              'LAMB_C_N',&
     &              'TOTO',&
     &              'LAMB_TT',&
     &              'D_LB_TT',&
     &              'LAMB_C_T'/
    data ncra19 / 'UN_SUR_K' ,&
     &              'VISC'     ,&
     &              'D_VISC_TEMP' ,&
     &              'ALPHA' /
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS GAZ ------------------
! =====================================================================
    data ncra20 / 'TOTO'    ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO' ,&
     &              'LAMB_T'   ,&
     &              'LAMB_TL'   ,&
     &              'LAMB_TN'   ,&
     &              'D_LB_T',&
     &              'D_LB_TL',&
     &              'D_LB_TN',&
     &              'LAMB_PHI'   ,&
     &              'D_LB_PHI',&
     &              'LAMB_CT',&
     &              'LAMB_C_L',&
     &              'LAMB_C_N',&
     &              'TOTO',&
     &              'LAMB_TT',&
     &              'D_LB_TT',&
     &              'LAMB_C_T'/
    data ncra21 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' /
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_VAPE ------------
! =====================================================================
    data ncra22 / 'TOTO'    ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO' ,&
     &              'LAMB_T'   ,&
     &              'LAMB_TL'   ,&
     &              'LAMB_TN'   ,&
     &              'D_LB_T' ,&
     &              'D_LB_TL',&
     &              'D_LB_TN',&
     &              'LAMB_PHI' ,&
     &              'D_LB_PHI' ,&
     &              'LAMB_S'   ,&
     &              'D_LB_S' ,&
     &              'LAMB_CT'  ,&
     &              'LAMB_C_L',&
     &              'LAMB_C_N',&
     &              'TOTO' ,'TOTO'  ,&
     &              'TOTO' , 'TOTO' ,&
     &              'TOTO' , 'TOTO' ,&
     &              'TOTO',&
     &              'TOTO',&
     &              'LAMB_TT',&
     &              'D_LB_TT',&
     &              'LAMB_C_T'/
    data ncra23 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' ,&
     &              'TOTO'    /
    data ncra24 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' /
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_VAPE_GAZ --------
! =====================================================================
    data ncra25 / 'TOTO'    ,'TOTO'   ,&
     &              'TOTO'   ,'TOTO'   ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO' ,&
     &              'LAMB_T'   ,&
     &              'LAMB_TL'   ,&
     &              'LAMB_TN'   ,&
     &              'D_LB_T' ,&
     &              'D_LB_TL',&
     &              'D_LB_TN',&
     &              'LAMB_PHI'   ,'D_LB_PHI' ,&
     &              'LAMB_S'   ,'D_LB_S' ,&
     &              'LAMB_CT'   ,&
     &              'LAMB_C_L',&
     &              'LAMB_C_N',&
     &              'TOTO' ,'TOTO' ,&
     &              'TOTO' ,'TOTO' ,&
     &              'TOTO' ,'TOTO' ,&
     &              'TOTO' ,'TOTO'  ,&
     &              'TOTO' ,'TOTO' ,&
     &              'TOTO'  ,'TOTO'   ,&
     &              'TOTO',&
     &              'TOTO',&
     &              'LAMB_TT',&
     &              'D_LB_TT',&
     &              'LAMB_C_T'/
    data ncra26 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' ,&
     &              'TOTO'  /
    data ncra27 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' /
    data ncra28 / 'TOTO' /
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_GAZ -------------
! =====================================================================
    data ncra29 / 'TOTO'    ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO' ,&
     &              'LAMB_T'   ,&
     &              'LAMB_TL'   ,&
     &              'LAMB_TN'   ,&
     &              'D_LB_T' ,&
     &              'D_LB_TL',&
     &              'D_LB_TN',&
     &              'LAMB_PHI'   ,'D_LB_PHI' ,&
     &              'LAMB_S'   ,'D_LB_S' ,&
     &              'LAMB_CT'  ,&
     &              'LAMB_C_L',&
     &              'LAMB_C_N',&
     &              'TOTO' ,&
     &              'TOTO' ,'TOTO' ,&
     &              'TOTO' ,'TOTO' ,&
     &              'TOTO' ,'TOTO',&
     &              'TOTO',&
     &              'LAMB_TT',&
     &              'D_LB_TT',&
     &              'LAMB_C_T'/
    data ncra30 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTOP' ,&
     &              'TOTO'  /
    data ncra31 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO'/
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_GAZ_ATM ---------
! =====================================================================
    data ncra32 / 'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'   ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO'  ,&
     &              'TOTO' ,&
     &              'LAMB_T'   ,&
     &              'LAMB_TL'   ,&
     &              'LAMB_TN'   ,&
     &              'D_LB_T',&
     &              'D_LB_TL',&
     &              'D_LB_TN',&
     &              'LAMB_PHI',&
     &              'D_LB_PHI' ,&
     &              'LAMB_S'   ,&
     &              'D_LB_S' ,&
     &              'LAMB_CT'   ,&
     &              'LAMB_C_L',&
     &              'LAMB_C_N',&
     &              'TOTO','TOTO' ,&
     &              'TOTO','TOTO',&
     &              'TOTO',&
     &              'LAMB_TT',&
     &              'D_LB_TT',&
     &              'LAMB_C_T'/
    data ncra33 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' ,&
     &              'TOTO'   /
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_AD_GAZ_VAPE -----
! =====================================================================
    data ncra40 / 'TOTO'    ,'TOTO'   ,&
     &               'TOTO'    , 'TOTO'  ,&
     &               'TOTO'   ,&
     &               'TOTO'  ,&
     &               'TOTO'  ,&
     &               'TOTO' ,&
     &               'LAMB_T'    ,&
     &               'LAMB_TL'   ,&
     &               'LAMB_TN'   ,&
     &               'D_LB_T' ,&
     &               'D_LB_TL',&
     &               'D_LB_TN',&
     &               'LAMB_PHI'    ,'D_LB_PHI' ,&
     &               'LAMB_S'    ,'D_LB_S' ,&
     &               'LAMB_CT'    ,&
     &               'LAMB_C_L',&
     &               'LAMB_C_N',&
     &               'TOTO' ,'TOTO' ,&
     &               'TOTO' ,'TOTO' ,&
     &               'TOTO' ,'TOTO' ,&
     &               'TOTO' ,'TOTO'  ,&
     &               'TOTO' ,'TOTO' ,&
     &               'TOTO'  ,'TOTO',&
     &               'TOTO','TOTO'  ,&
     &               'TOTO' , 'TOTO' ,&
     &               'TOTO'  ,'TOTO' ,&
     &               'TOTO',&
     &               'LAMB_TT',&
     &               'D_LB_TT',&
     &               'LAMB_C_T'/
    data ncra41 / 'TOTO' ,&
     &               'TOTO'     ,&
     &               'TOTO' ,&
     &               'TOTO'  /
    data ncra42 / 'TOTO' ,&
     &               'TOTO'     ,&
     &               'TOTO' /
    data ncra43 / 'TOTO' /
! =====================================================================
! --- DEFINITION DES DONNEES FINALES DANS LE CAS LIQU_AD_GAZ -----
! =====================================================================
!     DANS CRAD40 ON NE LIT PAS DE 21 A 26 INCLUS ET 38
    data crad40 / 'TOTO'    ,'TOTO'   ,&
     &                'TOTO'    , 'TOTO'  ,&
     &                'TOTO'   ,&
     &                'TOTO'  ,&
     &                'TOTO'  ,&
     &                'TOTO' ,&
     &                'LAMB_T'    ,&
     &                'LAMB_TL'   ,&
     &                'LAMB_TN'   ,&
     &                'D_LB_T' ,&
     &                'D_LB_TL',&
     &                'D_LB_TN',&
     &                'LAMB_PHI'    ,'D_LB_PHI' ,&
     &                'LAMB_S'    ,'D_LB_S' ,&
     &                'LAMB_CT'    ,&
     &                'LAMB_C_L',&
     &                'LAMB_C_N',&
     &                'TOTO' ,'TOTO' ,&
     &                'TOTO' ,'TOTO' ,&
     &                'TOTO' ,'TOTO' ,&
     &                'TOTO' ,'TOTO'  ,&
     &                'TOTO' ,'TOTO' ,&
     &                'TOTO'  ,'TOTO',&
     &                'TOTO','TOTO'  ,&
     &                'TOTO', 'TOTO' ,&
     &                'TOTO' ,'TOTO' ,&
     &                'TOTO',&
     &                'LAMB_TT',&
     &                'D_LB_TT',&
     &                'LAMB_C_T'/
    data crad41 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' ,&
     &              'TOTO'  /
    data crad42 / 'TOTO' ,&
     &              'TOTO'     ,&
     &              'TOTO' /
! =====================================================================
! --- CAS DE L'INITIALISATION -----------------------------------------
! =====================================================================

    retcom = 0
    un = 1.d0
    zero=0.d0
    aniso2 = 0
    aniso3 = 0
    aniso4 = 0
    lambct(:)=0.d0
    dlambt(:)=0.d0
!
    if (etape.eq.'FINALE') then
! =====================================================================
! --- CAS FINAL -------------------------------------------------------
! =====================================================================
        if (thmc .eq. 'LIQU_SATU') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_SATU -------------------------------
! =====================================================================
            do ii = 1, dim18
                val18(ii) = 0.0d0
            end do
            do ii = 1, dim19
                val19(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE FCT DE PHI
!
            val18(14) = 1.0d0
!
!       INITIALISATION POUR L'ANISOTROPIE
!
            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.0d0], 3, ncra18(1), val18(1), icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], dim19-1, ncra19, val19, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra18(8), val18(8), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra18(10), val18(10), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra18(9), val18(9), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra18(9), val18(9), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra18(20), val18(20), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra18(11), val18(11), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra18(13), val18(13), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra18(12), val18(12), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra18(12), val18(12), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra18(21), val18(21), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra18(14), val18(14), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra18(16), val18(16), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra18(18), val18(18), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra18(17), val18(17), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra18(17), val18(17), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra18(22), val18(22), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                            [t], 1, ncra19(4), val19(4), icodre,&
                            1)
            endif
!
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val18(14)
            dlambp = val18(15)
            lambs = 1.0d0
            dlambs = 0.0d0
            unsurk = val19(1)
            viscl = val19(2)
            dviscl = val19(3)
            alpha = val19(4)
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'GAZ') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE GAZ -------------------------------------
! =====================================================================
            do ii = 1, dim20
                val20(ii) = 0.0d0
            end do
            do ii = 1, dim21
                val21(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val20(15) = 1.0d0

            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 4, ncra20(1), val20(1), icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_GAZ', 1, 'TEMP',&
                        [t], dim21, ncra21, val21, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra20(9), val20(9), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra20(11), val20(11), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra20(10), val20(10), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra20(10), val20(10), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra20(21), val20(21), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra20(12), val20(12), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra20(14), val20(14), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra20(13), val20(13), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra20(13), val20(13), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra20(22), val20(22), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra20(15), val20(15), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra20(17), val20(17), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra20(19), val20(19), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra20(18), val20(18), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra20(18), val20(18), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra20(23), val20(23), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
            endif

            rgaz = val20( 1)
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val20(15)
            dlambp = val20(16)
            lambs = 1.0d0
            dlambs = 0.0d0
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
            mamolg = val21( 1)
            viscg = val21( 2)
            dviscg = val21( 3)
            lambs = 0.0d0
            dlambs = 0.0d0
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'LIQU_VAPE') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_VAPE -------------------------------
! =====================================================================
            do ii = 1, dim22
                val22(ii) = 0.0d0
            end do
            do ii = 1, dim23
                val23(ii) = 0.0d0
            end do
            do   ii = 1, dim24
                val24(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val22(15) = 1.0d0
            val22(17) = 1.0d0
!
            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 4, ncra22, val22, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], 3, ncra23, val23, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_VAPE_GAZ', 1, 'TEMP',&
                        [t], 3, ncra24, val24, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra22(9), val22(9), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra22(11), val22(11), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra22(10), val22(10), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra22(10), val22(10), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra22(30), val22(30), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra22(12), val22(12), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra22(14), val22(14), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra22(13), val22(13), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra22(13), val22(13), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra22(31), val22(31), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra22(15), val22(15), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra22(19), val22(19), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra22(21), val22(21), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra22(20), val22(20), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra22(20), val22(20), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra22(32), val22(32), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
!                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
!                            [t], dim23-3, ncra23(4), val23(4), icodre,&
!                            1)
            endif

            call thmEvalSatuFinal(hydr , imate , pvp-p1,&
                                  satur, dsatur, retcom)
! --------- Evaluate permeability for liquid and gaz
            call thmEvalPermLiquGaz(hydr  , imate , satur, p2, t,&
                                    permli, dperml,&
                                    permgz, dperms, dpermp)

            if (ther .ne. 'VIDE') then
                valpar(1) = satur
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'SAT',&
                            valpar(1), 2, ncra22(17), val22(17), icodre,&
                            0,nan='NON')
            endif
!
            rgaz = val22( 1)
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val22(15)
            dlambp = val22(16)
            lambs = val22(17)
            dlambs = val22(18)
            unsurk = val23( 1)
            viscl = val23( 2)
            dviscl = val23( 3)
            alpha = val23( 4)
            mamolv = val24( 1)
            viscvg = val24( 2)
            dvisvg = val24( 3)
!
            if (satur .gt. un .or. satur .lt. zero) then
                retcom = 2
                goto 500
            endif
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'LIQU_VAPE_GAZ') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_VAPE_GAZ ---------------------------
! =====================================================================
            do ii = 1, dim25
                val25(ii) = 0.0d0
            end do
            do ii = 1, dim26
                val26(ii) = 0.0d0
            end do
            do ii = 1, dim27
                val27(ii) = 0.0d0
            end do
            do ii = 1, dim28
                val28(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val25(15) = 1.0d0
            val25(17) = 1.0d0
            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 4, ncra25, val25, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], 3, ncra26, val26, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_GAZ', 1, 'TEMP',&
                        [t], 3, ncra27, val27, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_VAPE_GAZ', 0, ' ',&
                        [0.d0], 1, ncra28, val28, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra25(9), val25(9), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra25(11), val25(11), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra25(10), val25(10), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra25(10), val25(10), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra25(36), val25(36), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra25(12), val25(12), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra25(15), val25(15), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra25(14), val25(14), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra25(14), val25(14), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra25(38), val25(38), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra25(15), val25(15), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra25(19), val25(19), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra25(21), val25(21), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra25(20), val25(20), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra25(20), val25(20), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra25(38), val25(38), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
!                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
!                            [t], 1, ncra26(4), val26(4), icodre,&
!                            1)
            endif
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
! --------- Evaluate permeability for liquid and gaz
            call thmEvalPermLiquGaz(hydr  , imate , satur, p2, t,&
                                    permli, dperml,&
                                    permgz, dperms, dpermp)
            if (ther .ne. 'VIDE') then
                valpar(1) = satur
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'SAT',&
                            valpar(1), 2, ncra25(17), val25(17), icodre,&
                            0,nan='NON')
            endif

            rgaz = val25( 1)

            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val25(15)
            dlambp = val25(16)
            lambs = val25(17)
            dlambs = val25(18)

! --------- Evaluate Fick coefficients for steam in gaz
            call thmEvalFickSteam(imate,&
                                  satur, p2    , pvp   , t,&
                                  fick , dfickt, dfickg)
            mamolg = val27( 1)
            viscg = val27( 2)
            dviscg = val27( 3)
            mamolv = val28( 1)
!
            if (satur .gt. un .or. satur .lt. zero) then
                retcom = 2
                goto 500
            endif
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'LIQU_AD_GAZ_VAPE') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ_VAPE  --------------
! =====================================================================
            do ii = 1, dim40
                val40(ii) = 0.0d0
            end do
            do ii = 1, dim41
                val41(ii) = 0.0d0
            end do
            do ii = 1, dim42
                val42(ii) = 0.0d0
            end do
            do ii = 1, dim43
                val43(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val40(15) = 1.0d0
            val40(17) = 1.0d0
!
!
            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 4, ncra40, val40, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], 3, ncra41, val41, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_GAZ', 1, 'TEMP',&
                        [t], 3, ncra42, val42, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_VAPE_GAZ', 0, ' ',&
                        [0.d0], 1, ncra43, val43, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra40(9), val40(9), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra40(11), val40(11), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra40(10), val40(10), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra40(10), val40(10), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra40(41), val40(41), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra40(12), val40(12), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra40(14), val40(14), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra40(13), val40(13), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra40(13), val40(13), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra40(42), val40(42), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra40(15), val40(15), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra40(19), val40(19), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra40(21), val40(21), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra40(20), val40(20), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra40(20), val40(20), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra40(43), val40(43), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                            [t], dim41-3, ncra41(4), val41(4), icodre,&
                            1)
            endif
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
! --------- Evaluate permeability for liquid and gaz
            call thmEvalPermLiquGaz(hydr  , imate , satur, p2, t,&
                                    permli, dperml,&
                                    permgz, dperms, dpermp)
            if (ther .ne. 'VIDE') then
                valpar(1) = satur
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'SAT',&
                            valpar(1), 2, ncra40(17), val40(17), icodre,&
                            0,nan='NON')
            endif
!
            rgaz = val40( 1)
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val40(15)
            dlambp = val40(16)
            lambs = val40(17)
            dlambs = val40(18)
! --------- Evaluate Fick coefficients for steam in gaz
            call thmEvalFickSteam(imate,&
                                  satur, p2    , pvp   , t,&
                                  fick , dfickt, dfickg)
! --------- Evaluate Fick coefficients for air in liquid
            call thmEvalFickAir(imate,&
                                satur  , pad  , p2-p1, t,&
                                fickad , dfadt)
            unsurk = val41( 1)
            viscl = val41( 2)
            dviscl = val41( 3)
            alpha = val41( 4)
            mamolg = val42( 1)
            viscg = val42( 2)
            dviscg = val42( 3)
            mamolv = val43( 1)
!
            if (satur .gt. un .or. satur .lt. zero) then
                retcom = 2
                goto 500
            endif
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'LIQU_AD_GAZ') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ--------------
! =====================================================================
            do ii = 1, dim40
                val40(ii) = 0.0d0
            end do
            do ii = 1, dim41
                val41(ii) = 0.0d0
            end do
            do ii = 1, dim42
                val42(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val40(15) = 1.0d0
            val40(17) = 1.0d0

            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 4, crad40, val40, icodre,&
                        0,nan='NON')

            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], 3, crad41, val41, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_GAZ', 1, 'TEMP',&
                        [t], 3, crad42, val42, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, crad40(9), val40(9), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, crad40(11), val40(11), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, crad40(10), val40(10), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, crad40(10), val40(10), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, crad40(41), val40(41), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, crad40(12), val40(12), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, crad40(14), val40(14), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, crad40(13), val40(13), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, crad40(13), val40(13), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, crad40(42), val40(42), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, crad40(15), val40(15), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, crad40(19), val40(19), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, crad40(21), val40(21), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, crad40(20), val40(20), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, crad40(20), val40(20), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, crad40(43), val40(43), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                            [t], dim41-3, crad41(4), val41(4), icodre,&
                            1)
            endif
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
! --------- Evaluate permeability for liquid and gaz
            call thmEvalPermLiquGaz(hydr  , imate , satur, p2, t,&
                                    permli, dperml,&
                                    permgz, dperms, dpermp)
            if (ther .ne. 'VIDE') then
                valpar(1) = satur
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'SAT',&
                            valpar(1), 2, crad40(17), val40(17), icodre,&
                            0,nan='NON')
            endif
!
            rgaz = val40( 1)
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val40(15)
            dlambp = val40(16)
            lambs = val40(17)
            dlambs = val40(18)
! --------- Evaluate Fick coefficients for steam in gaz
            call thmEvalFickSteam(imate,&
                                  satur, p2    , pvp   , t,&
                                  fick , dfickt, dfickg)
! --------- Evaluate Fick coefficients for air in liquid
            call thmEvalFickAir(imate ,&
                                satur , pad  , p2-p1, t,&
                                fickad, dfadt)
!
            unsurk = val41( 1)
            viscl = val41( 2)
            dviscl = val41( 3)
            alpha = val41( 4)
            mamolg = val42( 1)
            viscg = val42( 2)
            dviscg = val42( 3)
!
            if (satur .gt. un .or. satur .lt. zero) then
                retcom = 2
                goto 500
            endif
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'LIQU_GAZ') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_GAZ --------------------------------
! =====================================================================
            do ii = 1, dim29
                val29(ii) = 0.0d0
            end do
            do ii = 1, dim30
                val30(ii) = 0.0d0
            end do
            do ii = 1, dim31
                val31(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val29(15) = 1.0d0
            val29(17) = 1.0d0
            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 4, ncra29, val29, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], 3, ncra30, val30, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_GAZ', 1, 'TEMP',&
                        [t], 3, ncra31, val31, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra29(9), val29(9), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra29(11), val29(11), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra29(10), val29(10), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra29(10), val29(10), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra29(30), val29(30), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra29(12), val29(12), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra29(14), val29(14), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra29(13), val29(13), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra29(13), val29(13), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra29(31), val29(31), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra29(15), val29(15), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra29(19), val29(19), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra29(21), val29(21), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra29(20), val29(20), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra29(20), val29(20), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra29(32), val29(32), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                            [t], dim30-3, ncra30(4), val30(4), icodre,&
                            1)
            endif
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
! --------- Evaluate permeability for liquid and gaz
            call thmEvalPermLiquGaz(hydr  , imate , satur, p2, t,&
                                    permli, dperml,&
                                    permgz, dperms, dpermp)
            if (ther .ne. 'VIDE') then
                valpar(1) = satur
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'SAT',&
                            valpar(1), 2, ncra29(17), val29(17), icodre,&
                            0,nan='NON')
            endif
            rgaz = val29( 1)
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val29(15)
            dlambp = val29(16)
            lambs = val29(17)
            dlambs = val29(18)
            unsurk = val30( 1)
            viscl = val30( 2)
            dviscl = val30( 3)
            alpha = val30( 4)
            mamolg = val31( 1)
            viscg = val31( 2)
            dviscg = val31( 3)
!
            if (satur .gt. un .or. satur .lt. zero) then
                retcom = 2
                goto 500
            endif
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        else if (thmc.eq.'LIQU_GAZ_ATM') then
! =====================================================================
! --- LOI DE COUPLAGE DE TYPE LIQU_GAZ_ATM ----------------------------
! =====================================================================
            do ii = 1, dim32
                val32(ii) = 0.0d0
            end do
            do ii = 1, dim33
                val33(ii) = 0.0d0
            end do
!
!       INITIALISATION POUR LA CONDUCTIVITE THERMIQUE
!
            val32(14) = 1.0d0
            val32(16) = 1.0d0

            call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                        [0.d0], 3, ncra32, val32, icodre,&
                        0,nan='NON')
            call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                        [t], 3, ncra33, val33, icodre,&
                        0,nan='NON')
            if (ther .ne. 'VIDE') then
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra32(8), val32(8), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra32(10), val32(10), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso2=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra32(9), val32(9), icodre,&
                                    0,nan='NON')
                    else
                        aniso2=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra32(9), val32(9), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra32(26), val32(26), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso2=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                            [t], 1, ncra32(11), val32(11), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra32(13), val32(13), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso3=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 2, ncra32(12), val32(12), icodre,&
                                    0,nan='NON')
                    else
                        aniso3=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra32(12), val32(12), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                    [t], 1, ncra32(27), val32(27), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso3=0
                endif
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'PORO',&
                            [phi], 2, ncra32(14), val32(14), icodre,&
                            0,nan='NON')
                call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                            [0.d0], 1, ncra32(18), val32(18), icodre,&
                            0,nan='NON')
                if (icodre(1) .eq. 1) then
                    call rcvala(imate, ' ', 'THM_DIFFU', 1, 'TEMP',&
                                [t], 1, ncra32(20), val32(20), icodre,&
                                0,nan='NON')
                    if (icodre(1) .eq. 0) then
                        aniso4=1
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 2, ncra32(19), val32(19), icodre,&
                                    0,nan='NON')
                    else
                        aniso4=2
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra32(19), val32(19), icodre,&
                                    0,nan='NON')
                        call rcvala(imate, ' ', 'THM_DIFFU', 0, ' ',&
                                    [0.d0], 1, ncra32(28), val32(28), icodre,&
                                    0,nan='NON')
                    endif
                else if (icodre(1).eq.0) then
                    aniso4=0
                endif
                call rcvala(imate, ' ', 'THM_LIQU', 1, 'TEMP',&
                            [t], dim33-3, ncra33(4), val33(4), icodre,&
                            1)
            endif
            call thmEvalSatuFinal(hydr , imate , p1    ,&
                                  satur, dsatur, retcom)
! --------- Evaluate permeability for liquid
            call thmEvalPermLiquGaz(hydr  , imate , satur, p2, t,&
                                    permli, dperml)
            if (ther .ne. 'VIDE') then
                valpar(1) = satur
                call rcvala(imate, ' ', 'THM_DIFFU', 1, 'SAT',&
                            valpar(1), 2, ncra32(16), val32(16), icodre,&
                            0,nan='NON')
            endif
            lambt(1)  = ds_thm%ds_material%ther%lambda
            lambt(2)  = ds_thm%ds_material%ther%lambda_tl
            lambt(3)  = ds_thm%ds_material%ther%lambda_tn
            lambt(4)  = ds_thm%ds_material%ther%lambda_tt
            dlambt(1) = ds_thm%ds_material%ther%dlambda
            dlambt(2) = ds_thm%ds_material%ther%dlambda_tl
            dlambt(3) = ds_thm%ds_material%ther%dlambda_tn
            dlambt(4) = ds_thm%ds_material%ther%dlambda_tt
            lambct(1) = ds_thm%ds_material%ther%lambda_ct
            lambct(2) = ds_thm%ds_material%ther%lambda_ct_l
            lambct(3) = ds_thm%ds_material%ther%lambda_ct_n
            lambct(4) = ds_thm%ds_material%ther%lambda_ct_t
            lambp = val32(14)
            dlambp = val32(15)
            lambs = val32(16)
            dlambs = val32(17)
            unsurk = val33(1)
            viscl = val33(2)
            dviscl = val33(3)
            alpha = val33(4)
!
            if (satur .gt. un .or. satur .lt. zero) then
                retcom = 2
                goto 500
            endif
! --------- Compute tensor of thermal conductivity
            call telamb(angmas, ndim, tlambt)
! --------- Compute tensor of thermal conductivity (constant part)
            call tlambc(angmas, ndim, tlamct)
!
! CALCUL DU TENSEUR DERIVEE DE LA CONDUCTIVITE THERMIQUE(T)
            call tdlamb(angmas, dlambt, tdlamt, aniso3, ndim)
!
        endif
    endif
500 continue
!
! =====================================================================
end subroutine
