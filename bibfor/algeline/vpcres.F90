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

subroutine vpcres(eigsol, typres, raide, masse, amor, optiof, method, modrig, arret, tabmod,&
                stoper, sturm, typcal, appr, typeqz, nfreq, nbvect, nbvec2, nbrss, nbborn, nborto,&
                nitv, itemax, nperm, maxitr, vectf, precsh, omecor, precdc, seuil,&
                prorto, prsudg, tol, toldyn, tolsor, alpha)
! -------------------------------------------------------------------------------------------------
!
! CREATION ET REMPLISSAGE DE LA SD EIGSOL ASSOCIEE AUX PARAMETRES MODAUX FOURNIS EN PARAMETRE
! DEFINITION DES SIGNIFICATIONS DE CES PARAMETRES DANS VPINIS (VIA LES GETVTX...)
! CF VPINIS, VPLECS, VPLECI, VPECRI.
!
! -------------------------------------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
    implicit none

#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/sdeiso.h"
#include "asterfort/vecini.h"
#include "asterfort/vecink.h"
#include "asterfort/vecint.h"
#include "asterfort/wkvect.h"

!
! --- INPUT
!
    integer           , intent(in) :: nfreq, nbvect, nbvec2, nbrss, nbborn, nborto, nitv, itemax
    integer           , intent(in) :: nperm, maxitr
    real(kind=8)      , intent(in) :: vectf(2), precsh, omecor, precdc, seuil
    real(kind=8)      , intent(in) :: prorto, prsudg, tol, toldyn, tolsor, alpha
    character(len=1)  , intent(in) :: appr
    character(len=8)  , intent(in) :: method, arret
    character(len=16) , intent(in) :: typres, optiof, modrig, stoper, sturm, typcal, typeqz
    character(len=19) , intent(in) :: eigsol, raide, masse, amor, tabmod
!
! --- OUTPUT
! None
!
! --- INPUT/OUTPUT
! None
!
! --- VARIABLES LOCALES
!
    integer           :: indf, zslvk, zslvr, zslvi, eislvk, eislvr, eislvi
    real(kind=8)      :: undf
    character(len=24) :: kzero
!
! -----------------------
! --- CORPS DE LA ROUTINE
! -----------------------
!

! --- INITS.
    call jemarq()
    undf=r8vide()
    indf=isnnem()
    kzero=' '

! --- CREATION-INITIALISATION DE LA SD
    zslvk = sdeiso('ZSLVK')
    zslvr = sdeiso('ZSLVR')
    zslvi = sdeiso('ZSLVI')

    call wkvect(eigsol//'.ESVK', 'V V K24', zslvk, eislvk)
    call wkvect(eigsol//'.ESVR', 'V V R', zslvr, eislvr)
    call wkvect(eigsol//'.ESVI', 'V V I', zslvi, eislvi)
    call vecink(zslvk,kzero,zk24(eislvk))
    call vecini(zslvr, undf,zr(eislvr))
    call vecint(zslvi,indf,zi(eislvi))


! --  PARAMETRES K24 GENERAUX
    zk24(eislvk-1+1)=trim(typres)
    zk24(eislvk-1+2)=trim(raide)
    zk24(eislvk-1+3)=trim(masse)
    zk24(eislvk-1+4)=trim(amor)
    zk24(eislvk-1+5)=trim(optiof)
    zk24(eislvk-1+6)=trim(method)
    zk24(eislvk-1+7)=trim(modrig)
    zk24(eislvk-1+8)=trim(arret)
    zk24(eislvk-1+9)=trim(tabmod)
    zk24(eislvk-1+10)=trim(stoper)
    zk24(eislvk-1+11)=trim(sturm)
    zk24(eislvk-1+12)=trim(typcal)

! --  PARAMETRES K24 LIES AUX SOLVEURS MODAUX
    zk24(eislvk-1+16)=trim(appr)
    select case(method)
    case('TRI_DIAG')
    case ('JACOBI')
    case ('SORENSEN')
    case ('QZ')
        zk24(eislvk-1+17)=trim(typeqz)
    case default
        ASSERT(.false.)
    end select

! --  PARAMETRES ENTIERS GENERAUX
    zi(eislvi-1+1)=nfreq
    zi(eislvi-1+2)=nbvect
    zi(eislvi-1+3)=nbvec2
    zi(eislvi-1+4)=nbrss
    zi(eislvi-1+5)=nbborn

! -- PARAMETRES ENTIERS LIES AUX SOLVEURS MODAUX
    select case(method)
    case('TRI_DIAG')
        zi(eislvi-1+11)=nborto
        zi(eislvi-1+12)=nitv
    case ('JACOBI')
        zi(eislvi-1+11)=itemax
        zi(eislvi-1+12)=nperm
    case ('SORENSEN')
        zi(eislvi-1+11)=maxitr
    case ('QZ')
    case default
        ASSERT(.false.)
    end select

! --  PARAMETRES REELS GENERAUX
    zr(eislvr-1+1)=vectf(1)
    zr(eislvr-1+2)=vectf(2)
    zr(eislvr-1+3)=precsh
    zr(eislvr-1+4)=omecor
    zr(eislvr-1+5)=precdc
    zr(eislvr-1+6)=seuil

! --  PARAMETRES REELS LIES AUX SOLVEURS MODAUX
    select case(method)
    case('TRI_DIAG')
        zr(eislvr-1+11)=prorto
        zr(eislvr-1+12)=prsudg
    case ('JACOBI')
        zr(eislvr-1+11)=tol
        zr(eislvr-1+12)=toldyn
    case ('SORENSEN')
        zr(eislvr-1+11)=tolsor
        zr(eislvr-1+12)=alpha
    case ('QZ')
    case default
        ASSERT(.false.)
    end select
    
    call jedema()
!
end subroutine
