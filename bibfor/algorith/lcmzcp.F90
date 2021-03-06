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

subroutine lcmzcp(fami, kpg, ksp, ndim, imate,&
                  epsm, deps, vim, &
                  option, sig, vip, dsidep)
    implicit none
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/mazacp.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
#include "asterfort/get_varc.h"
    character(len=16) :: option
    character(len=*) :: fami
    integer :: ndim, imate, kpg, ksp
    real(kind=8) :: epsm(*), deps(*), vim(*)
    real(kind=8) :: sig(*), vip(*), dsidep(6, 6)
! --- ------------------------------------------------------------------
!
!                 LOI DE COMPORTEMENT : MAZARS EN CP
!
! --- ------------------------------------------------------------------
!
! IN
!     FAMI    : FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!     KPG     : NUMERO DU POINT DE GAUSS
!     KSP     : NUMERO DU SOUS-POINT
!     NDIM    : DIMENSION DE L'ESPACE
!     IMATE   : MATERIAU
!     EPSM    : DEFORMATION EN T-
!     DEPS    : INCREMENT DE DEFORMATION
!     VIM     : VARIABLES INTERNES EN T-
!     TM      : TEMPERATURE EN T-
!     TP      : TEMPERATURE EN T+
!     TREF    : TEMPERATURE DE REFERENCE
!     OPTION  : OPTION DEMANDEE
!                 RIGI_MECA_TANG ->     DSIDEP      --> RIGI
!                 FULL_MECA      -> SIG DSIDEP VIP  --> RIGI  RESI
!                 RAPH_MECA      -> SIG        VIP  -->       RESI
! OUT
!     SIG     : CONTRAINTE
!     VIP     : VARIABLES INTERNES en T+
!     DSIDEP  : MATRICE TANGENTE
!
! --- ------------------------------------------------------------------
!     VARIABLES INTERNES
!        1  -> ICELS  : CRITERE SIGMA
!        2  -> ICELU  : CRITERE EPSI
!        3  -> IDOMM  : ENDOMMAGEMENT
!        4  -> IEPSQT : VALEUR DE EPSEQP DE TRACTION
!        5  -> IEPSQC : VALEUR DE EPSEQP DE COMPRESSION
!        6  -> IRSIGM : FACTEUR DE TRIAXIALITE EN CONTRAINTE
!        7  -> ITEMP  : TEMPERATURE MAXIMALE ATTEINTE PAR LE MATERIAU
!        8  -> IDISSD : DISSIPATION D'ENDOMMAGEMENT
! --- ------------------------------------------------------------------
!     INDEX DES VARIABLES INTERNES
    integer :: itemp
    parameter     (itemp=7)
!
    integer :: nbval
    parameter     (nbval=8)
    integer :: icodre(nbval)
    character(len=16) :: nomres(nbval)
    character(len=8) :: mazars(nbval)
    real(kind=8) :: valres(nbval+1)
!
    aster_logical :: resi
    integer :: ndimsi, iret
    real(kind=8) :: epsthe, kdess, bendo, epsane
    real(kind=8) :: ee, nu
    real(kind=8) :: temp, tmax, tmaxm, hydr, sech, sref
    real(kind=8) :: valpar, tm, tp, tref
    character(len=1) :: poum
    character(len=8) :: nompar
    character(len=30) :: valkm(3)
!
    data mazars /'EPSD0','K','AC','BC','AT','BT',&
     &             'SIGM_LIM','EPSI_LIM'/
!
!
! ----------------------------------------------------------------------
!
!
! - Get temperatures
!
    call get_varc(fami , kpg  , ksp , 'T',&
                  tm, tp, tref)

!       RIGI  = (OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL')
    resi = (option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL')
!
    ndimsi = 2*ndim
!
!     DETERMINATION DE LA TEMPERATURE DE REFERENCE (TMAX) ET
!     DES CONDITIONS D HYDRATATION OU DE SECHAGE
    tmaxm = vim(itemp)
    call rcvarc(' ', 'SECH', 'REF', fami, kpg,&
                ksp, sref, iret)
    if (iret .ne. 0) sref = 0.0d0
    if (resi) then
        temp = tp
        call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                    ksp, hydr, iret)
        if (iret .ne. 0) hydr = 0.0d0
        poum='+'
        call rcvarc(' ', 'SECH', '+', fami, kpg,&
                    ksp, sech, iret)
        if (iret .ne. 0) sech = 0.0d0
        if (isnan(tp)) then
            tmax = r8nnem()
            vip(itemp) = 0.0d0
        else
            tmax = max(tmaxm, tp)
            if (tmax .gt. tmaxm) vip(itemp) = tmax
        endif
    else
        temp = tm
        call rcvarc(' ', 'HYDR', '-', fami, kpg,&
                    ksp, hydr, iret)
        if (iret .ne. 0) hydr = 0.0d0
        call rcvarc(' ', 'SECH', '-', fami, kpg,&
                    ksp, sech, iret)
        if (iret .ne. 0) sech = 0.0d0
        poum='-'
        tmax = tmaxm
    endif
!
!     RECUPERATION DES CARACTERISTIQUES MATERIAUX QUI PEUVENT VARIER
!     AVEC LA TEMPERATURE (MAXIMALE), L'HYDRATATION OU LE SECHAGE
    nompar = 'TEMP'
    valpar = tmax
!     LECTURE DES CARACTERISTIQUES ELASTIQUES
    nomres(1) = 'E'
    nomres(2) = 'NU'
    nomres(3) = 'ALPHA'
    call rcvalb(fami, kpg, ksp, poum, imate,&
                ' ', 'ELAS', 1, nompar, [valpar],&
                2, nomres, valres, icodre, 1)
    call rcvalb(fami, kpg, ksp, poum, imate,&
                ' ', 'ELAS', 1, nompar, [valpar],&
                1, nomres(3), valres(3), icodre(3), 0)
    if ((.not.isnan(tp)) .and. (.not.isnan(tm))) then
        if ((isnan(tref)) .or. (icodre(3).ne.0)) then
            call utmess('F', 'CALCULEL_15')
        else
            epsthe = valres(3)*(temp-tref)
        endif
    else
        valres(3) = 0.0d0
        epsthe = 0.0d0
    endif
    ee = valres(1)
    nu = valres(2)
!
!     LECTURE DU RETRAIT ENDOGENE ET RETRAIT DE DESSICCATION
    nomres(1)='B_ENDOGE'
    nomres(2)='K_DESSIC'
    call rcvala(imate, ' ', 'ELAS', 0, ' ',&
                [0.0d0], 2, nomres, valres, icodre,&
                0)
    if (icodre(1) .ne. 0) valres(1) = 0.0d0
    if (icodre(2) .ne. 0) valres(2) = 0.0d0
    bendo = valres(1)
    kdess = valres(2)
!     DEFORMATION ANELASTIQUE : THERMIQUE, SECHAGE, HYDRATATION
    epsane = (epsthe-kdess*(sref-sech)-bendo*hydr)
!
! --- ON RECUPERE LES PARAMETRES MATERIAU
    call r8inir(nbval, 0.d0, valres, 1)
    call rcvalb(fami, kpg, ksp, poum, imate,&
                ' ', 'MAZARS', 1, nompar, [valpar],&
                nbval, mazars, valres, icodre, 1)
    if (icodre(7)+icodre(8) .ne. 0) then
        valkm(1)='MAZARS_GC'
        valkm(2)=mazars(7)
        valkm(3)=mazars(8)
        call utmess('F', 'COMPOR1_76', nk=3, valk=valkm)
    endif
! --- AJOUT DE NU DANS VALRES
    valres(nbval+1) = nu
!     LOI DE MAZARS EN CONTRAINTES PLANES
    call mazacp(option, ndimsi, epsm, deps, epsane,&
                ee, valres, vim, vip, sig,&
                dsidep)
end subroutine
