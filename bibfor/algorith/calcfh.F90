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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1501,W1504
!
subroutine calcfh(option, perman, thmc, ndim, dimdef,&
                  dimcon, yamec, yate, addep1, addep2,&
                  adcp11, adcp12, adcp21, adcp22, addeme,&
                  addete, congep, dsde, p1, p2,&
                  grap1, grap2, t, grat, pvp,&
                  pad, rho11, h11, h12, r,&
                  dsatp1, pesa, tperm, permli, dperml,&
                  krel2, dkr2s, dkr2p, fick, dfickt,&
                  dfickg, fickad, dfadt, kh, cliq,&
                  alpliq, viscl, dviscl, mamolg, viscg,&
                  dviscg, mamolv,&
                  j_mater ,hydr, satur)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/hmderp.h"
#include "asterfort/utmess.h"
#include "asterfort/calcfh_gazp.h"
#include "asterfort/calcfh_lisa.h"
#include "asterfort/calcfh_liva.h"
#include "asterfort/calcfh_lvag.h"
#include "asterfort/calcfh_liga.h"
#include "asterfort/calcfh_lgat.h"
#include "asterfort/calcfh_lvga.h"
#include "asterfort/calcfh_ladg.h"
!
! ======================================================================
! ROUTINE CALC_FLUX_HYDRO
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE DES FLUX
! HYDRAULIQUES AU POINT DE GAUSS CONSIDERE
! ======================================================================
! IN CORRESPONDANCE ANCIENNE PROGRAMMATION -----------------------------
! COND(1) -> PERMFH : PERM_IN OU PERM_END SOUS THM_DIFFU ---------------
! COND(2) -> PERMLI : PERM_LIQU SOUS THM_DIFFU ---------------
! COND(3) -> DPERML : D_PERM_LIQU SOUS THM_DIFFU ---------------
! COND(4) -> KREL2 : PERM_GAZ SOUS THM_DIFFU ---------------
! COND(5) -> DKR2S : D_PERM_SATU_GAZ SOUS THM_DIFFU ---------------
! COND(6) -> DKR2P : D_PERM_PRES_GAZ SOUS THM_DIFFU ---------------
! COND(7) -> FICK : FICK SOUS THM_DIFFU ---------------
! COND(8) -> DFICKT : D_FICK_TEMP SOUS THM_DIFFU ---------------
! COND(9) -> DFICKG : D_FICK_GAZ_PRES SOUS THM_DIFFU ---------------
! ======================================================================
! CETTE ROUTINE EST APPELLE POUR LES EF
!
    integer :: ndim, dimdef, dimcon, yamec, yate, adcp22
    integer :: addeme, addep1, addep2, addete, adcp11, adcp12, adcp21
    integer :: j_mater
    real(kind=8) :: congep(1:dimcon), kh
    real(kind=8) :: dsde(1:dimcon, 1:dimdef), p1, grap1(3), p2, t
    real(kind=8) :: grap2(3), grat(3), pvp, pad, h11, h12, rho11
    real(kind=8) :: r, dsatp1, pesa(3), tperm(ndim, ndim)
    real(kind=8) :: permli, dperml, krel2, dkr2s, dkr2p, fick
    real(kind=8) :: dfickt, dfickg, cliq, alpliq
    real(kind=8) :: fickad, dfadt
    real(kind=8) :: viscl, dviscl, viscg, dviscg
    real(kind=8) :: mamolg, mamolv, satur
    character(len=16) :: option, thmc, hydr
    aster_logical :: perman
 
!
! - Prepare select
!
    if (thmc .eq. 'LIQU_SATU') then
        call calcfh_lisa(option, perman, ndim,&
                         dimdef, dimcon,&
                         yamec , yate  ,&
                         addep1, adcp11, addeme, addete,&
                         grap1 , rho11 , pesa  , tperm ,&
                         congep, dsde  )
    endif
    if (thmc .eq. 'GAZ') then
        call calcfh_gazp(option, perman , ndim,&
                         dimdef, dimcon ,&
                         yamec , yate   ,&
                         addep1, adcp11 , addeme, addete,&
                         t     , p1     , grap1 ,&
                         rho11 , pesa   , tperm ,&
                         congep, dsde)
    endif
    if (thmc .eq. 'LIQU_VAPE') then
        call calcfh_liva(option, hydr  , ndim, j_mater,&
                         dimdef, dimcon,&
                         yamec , yate  ,&
                         addep1, adcp11, adcp12, addeme, addete,&
                         t     , p2    , pvp,&
                         grap1 , grat  ,&
                         rho11 , h11   , h12    ,&
                         satur , dsatp1, pesa   , tperm,&
                         congep, dsde  )
    endif
    if (thmc .eq. 'LIQU_VAPE_GAZ') then
        call calcfh_lvag(option, perman, hydr   , ndim  , j_mater,&
                         dimdef, dimcon,&
                         yamec , yate  ,&
                         addep1, addep2, adcp11 , adcp12, adcp21 ,&
                         addeme, addete, &
                         t     , p2    , pvp    ,&
                         grat  , grap1 , grap2  ,& 
                         rho11 , h11   , h12    ,&
                         satur , dsatp1, pesa   , tperm,&
                         congep, dsde)
    endif
    if (thmc .eq. 'LIQU_GAZ') then
        call calcfh_liga(option, hydr  , ndim  , j_mater,&
                         dimdef, dimcon,&
                         yamec , yate  ,&
                         addep1, addep2, adcp11 , adcp21 ,&
                         addeme, addete, &
                         t     , p2    , &
                         grap1 , grap2  ,& 
                         rho11 , &
                         satur , dsatp1, pesa   , tperm,&
                         congep, dsde)
    endif
    if (thmc .eq. 'LIQU_GAZ_ATM') then
        call calcfh_lgat(option, perman , hydr  , ndim  , j_mater,&
                         dimdef, dimcon ,&
                         yamec , yate   ,&
                         addep1, adcp11 ,&
                         addeme, addete ,&
                         t     , p2     ,&
                         grap1 , & 
                         rho11 , &
                         satur , dsatp1 , pesa , tperm,&
                         congep, dsde)
    endif
    if (thmc .eq. 'LIQU_AD_GAZ_VAPE') then
        call calcfh_lvga(option, perman, hydr  , ndim  , j_mater,&
                         dimdef, dimcon,&
                         yamec , yate  ,&
                         addep1, addep2, adcp11 , adcp12, adcp21 , adcp22,&
                         addeme, addete, &
                         t     , p1    , p2     , pvp   , pad,&
                         grat  , grap1 , grap2  ,& 
                         rho11 , h11   , h12    ,&
                         satur , dsatp1, pesa, tperm,&
                         congep, dsde)
    endif
    if (thmc .eq. 'LIQU_AD_GAZ') then
        call calcfh_ladg(option, perman, hydr  , ndim  , j_mater,&
                         dimdef, dimcon,&
                         yamec , yate  ,&
                         addep1, addep2, adcp11 , adcp12, adcp21 , adcp22,&
                         addeme, addete, &
                         t     , p1    , p2     , pvp   , pad,&
                         grat  , grap1 , grap2  ,& 
                         rho11 , h11   , h12    ,&
                         satur , dsatp1, pesa, tperm,&
                         congep, dsde)
    endif
!
end subroutine
