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

subroutine vpinis(eigsol)
! LECTURE DES PARAMETRES SOLVEUR MODAL ET CREATION DE LA SD ASSOCIEE
! CF VPINIS, VPLECS, VPLECI, VPECRI.
! RQ1. ON CREE LES OBJETS GLOBAUX LIES A EIGSOL SUR BASE VOLATILE.
!      ILS SONT DETRUITS DANS VPPOST.
! -------------------------------------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
    implicit none

#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/omega2.h"
#include "asterfort/vpcres.h"
!
! --- INPUT
!
    character(len=19) , intent(in) :: eigsol
!
! --- OUTPUT
! None
!
! --- INPUT/OUTPUT
! None
!
! --- VARIABLES LOCALES
!
    integer           :: iret, ibuff, itemax, nbborn, nborto, nbrss
    integer           :: nbvect, nbvec2, nfreq, nitv, nperm, maxitr
    real(kind=8)      :: alpha, fcorig, omecor, precsh, precdc, prorto, prsudg, seuil, undf
    real(kind=8)      :: tol, toldyn, tolsor, vectf(2)
    character(len=1)  :: appr
    character(len=8)  :: arret, method
    character(len=9)  :: typevp
    character(len=14) :: matra, matrb, matrc
    character(len=16) :: optiof, modrig, stoper, sturm, typeqz, typres, typcal
    character(len=19) :: amor, k19b, masse, tabmod, raide

!
! -----------------------
! --- CORPS DE LA ROUTINE
! -----------------------
!

! --- INITS.
    call jemarq()
    undf=r8vide()


! --- LECTURE DES PARAMETRES COMMUNS A TOUS LES SOLVEURS MODAUX

! --  TYPE_RESU
    typres=''
    call getvtx(' ', 'TYPE_RESU', iocc=1, scal=typres, nbret=iret)
    ASSERT(iret.eq.1)
! --  CATALOGUE DE COMMANDE, DIFFERENT SELON LE TYPE_RESU
!     -> ON STOCKE DANS DES VARIABLES POUR EVITER DE FAIRE DES GETXXX
!     POUR CHAQUE TYPE_RESU.
!     POUR L'INSTANT TYPE_RESU='GENERAL' REVIENT A 'MODE_FLAMB' SAUF LE NOM DES MATRICES
    select case(typres)
    case('DYNAMIQUE')
        matra ='MATR_RIGI'
        matrb ='MATR_MASS'
        matrc ='MATR_AMOR'
        typevp='FREQ'
    case('MODE_FLAMB')
        matra ='MATR_RIGI'
        matrb ='MATR_RIGI_GEOM'
        typevp='CHAR_CRIT'
    case('GENERAL')
        matra ='MATR_A'
        matrb ='MATR_B'
        matrc ='MATR_C'
        typevp='CHAR_CRIT'
        typres='MODE_FLAMB'
    case default
        ASSERT(.false.)
    end select

! --  CALC_FREQ/CHAR_CRIT
    optiof=''
    call getvtx('CALC_'//typevp, 'OPTION', iocc=1, scal=optiof, nbret=iret)
    ASSERT(iret.eq.1)

! --  MATRA/MATRB/MATRC
    raide=''
    call getvid(' ', matra, iocc=1, scal=raide, nbret=iret)
    ASSERT(iret.eq.1)
    masse=''
    call getvid(' ', matrb, iocc=1, scal=masse, nbret=iret)
    ASSERT(iret.eq.1)
    if (typres(1:10).ne.'MODE_FLAMB') then
        k19b=''
        call getvid(' ', matrc, iocc=1, scal=k19b, nbret=iret)
        if (iret.eq.1) then
           amor=trim(k19b)
        else
           amor=''
        endif
    else
        amor=''
    endif

! --  METHODE
    method=''
    call getvtx(' ', 'METHODE', iocc=1, scal=method, nbret=iret)
    ASSERT(iret.eq.1)

! --  DETECTION DES MODES DE CORPS RIGIDE
    modrig=''
    call getvtx(' ', 'OPTION', iocc=1, scal=modrig, nbret=iret)
    ASSERT(iret.eq.1)

! -- NOMBRE DE MODES DEMANDES
    call getvis('CALC_'//typevp, 'NMAX_'//typevp, iocc=1, scal=ibuff, nbret=iret)
    if (iret.eq.1) then
        nfreq=ibuff
    else
        nfreq=0
    endif

! -- LISTES DES FREQUENCES/CHARGES CRITIQUES OU TABLE_ASTER
    vectf(1)=undf
    vectf(2)=undf
    call getvr8('CALC_'//typevp, typevp, iocc=1, nbval=0, nbret=iret)
    if (iret.lt.0) then
        nbborn=-iret
        ASSERT((nbborn.eq.1).or.(nbborn.eq.2))
        call getvr8('CALC_'//typevp, typevp, iocc=1, nbval=nbborn, vect=vectf, nbret=iret)
        ASSERT(iret.eq.nbborn)
    else
        nbborn=0
    endif

    call getvid('CALC_'//typevp, 'TABLE_'//typevp, iocc=1, scal=k19b, nbret=iret)
    if (iret.eq.1) then
        tabmod=trim(k19b)
    else
        tabmod=''
    endif

! --  PARAMETRES ESPACE REDUIT
    call getvis('CALC_'//typevp, 'DIM_SOUS_ESPACE', iocc=1, scal=ibuff, nbret=iret)
    if (iret.eq.1) then
        nbvect=ibuff
    else
        nbvect=0
    endif
    call getvis('CALC_'//typevp, 'COEF_DIM_ESPACE', iocc=1, scal=ibuff, nbret=iret)
    if (iret.eq.1) then
        nbvec2=ibuff
    else
        nbvec2=0
    endif

! --  PARAMETRES SHIFT PRETRAITEMENTS
    call getvis('CALC_'//typevp, 'NMAX_ITER_SHIFT', iocc=1, scal=nbrss, nbret=iret)
    ASSERT(iret.eq.1)
    call getvr8('CALC_'//typevp, 'PREC_SHIFT', iocc=1, scal=precsh, nbret=iret)
    ASSERT(iret.eq.1)
    call getvr8('CALC_'//typevp, 'SEUIL_'//typevp, iocc=1, scal=fcorig, nbret=iret)
    ASSERT(iret.eq.1)
    if (typres(1:9) .eq. 'DYNAMIQUE') then
        omecor = omega2(fcorig)
    else
        omecor = fcorig
    endif
 
! --  PARAMETRES DES SOLVEURS MODAUX
    appr=''
    call getvtx('CALC_'//typevp, 'APPROCHE', iocc=1, scal=appr, nbret=iret)
    ASSERT(iret.eq.1)

! --  PARAM LANCZOS
    select case(method)
    case('TRI_DIAG')
        call getvis(' ', 'NMAX_ITER_ORTHO', iocc=1, scal=nborto, nbret=iret)
        ASSERT(iret.eq.1)
        call getvr8(' ', 'PREC_ORTHO', iocc=1, scal=prorto, nbret=iret)
        ASSERT(iret.eq.1)
        call getvr8(' ', 'PREC_LANCZOS', iocc=1, scal=prsudg, nbret=iret)
        ASSERT(iret.eq.1)
        call getvis(' ', 'NMAX_ITER_QR', iocc=1, scal=nitv, nbret=iret)
        ASSERT(iret.eq.1)
! --  PARAM JACOBI
    case ('JACOBI')
        call getvis(' ', 'NMAX_ITER_BATHE ', iocc=1, scal=itemax, nbret=iret)
        ASSERT(iret.eq.1)
        call getvr8(' ', 'PREC_BATHE', iocc=1, scal=tol, nbret=iret)
        ASSERT(iret.eq.1)
        call getvis(' ', 'NMAX_ITER_JACOBI', iocc=1, scal=nperm, nbret=iret)
        ASSERT(iret.eq.1)
        call getvr8(' ', 'PREC_JACOBI', iocc=1, scal=toldyn, nbret=iret)
        ASSERT(iret.eq.1)
! --  PARAM SORENSEN
    case ('SORENSEN')
        call getvr8(' ', 'PREC_SOREN', iocc=1, scal=tolsor, nbret=iret)
        ASSERT(iret.eq.1)
        call getvis(' ', 'NMAX_ITER_SOREN', iocc=1, scal=maxitr, nbret=iret)
        ASSERT(iret.eq.1)
        call getvr8(' ', 'PARA_ORTHO_SOREN', iocc=1, scal=alpha, nbret=iret)
        ASSERT(iret.eq.1)
! --  PARAM QZ
    case ('QZ')
        typeqz=''
        call getvtx(' ', 'TYPE_QZ', scal=typeqz, nbret=iret)
        ASSERT(iret.eq.1)
    case default
        ASSERT(.false.)
    end select

! --  PARAMETRES POST-TRAITEMENTS
    call getvr8('VERI_MODE', 'PREC_SHIFT', iocc=1, scal=precdc, nbret=iret)
    ASSERT(iret.eq.1)
    stoper=''
    call getvtx('VERI_MODE', 'STOP_ERREUR', iocc=1, scal=stoper, nbret=iret)
    ASSERT(iret.eq.1)
    sturm=''
    call getvtx('VERI_MODE', 'STURM', iocc=1, scal=sturm, nbret=iret)
    ASSERT(iret.eq.1)
    call getvr8('VERI_MODE', 'SEUIL', iocc=1, scal=seuil, nbret=iret)
    ASSERT(iret.eq.1)

! -- DIVERS
    arret=''
    call getvtx(' ', 'STOP_BANDE_VIDE', scal=arret, nbret=iret)
    ASSERT(iret.eq.1)
    typcal='TOUT'

! --- CREATION ET REMPLISSAGE DE LA SD
    call vpcres(eigsol, typres, raide, masse, amor, optiof, method, modrig, arret, tabmod,&
                  stoper, sturm, typcal, appr, typeqz, nfreq, nbvect, nbvec2, nbrss, nbborn,&
                  nborto, nitv, itemax, nperm, maxitr, vectf, precsh, omecor, precdc, seuil,&
                  prorto, prsudg, tol, toldyn, tolsor, alpha)    
    call jedema()
!
!     FIN DE VPINIS
!
end subroutine
