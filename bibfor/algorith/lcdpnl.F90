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

subroutine lcdpnl(fami, typmod, ndim,&
                  option, compor, imate, sigm, deps,&
                  vim, vip, sig, dsidep, proj,&
                  iret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lcdrpr.h"
#include "asterfort/lcinma.h"
#include "asterfort/lcprsm.h"
#include "asterfort/lcsoma.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
!
!
    integer :: ndim, imate, iret
    real(kind=8) :: sigm(6), deps(6, 2), vim(*), vip(*), sig(6), proj(6, 6)
    real(kind=8) :: dsidep(6, 6, 2)
    character(len=*) :: fami
    character(len=8) :: typmod(*)
    character(len=16) :: option, compor(*)
!
! =====================================================================
! --- APPLICATION DE LA LOI DE COMPORTEMENT DE TYPE DRUCKER PRAGER ----
! --- LINEAIRE AVEC PRISE EN COMPTE DES PHENOMENES DE NON LOCALISATION
! =====================================================================
! IN  NDIM    DIMENSION DE L'ESPACE
! IN  OPTION  OPTION DE CALCUL (RAPH_MECA, RIGI_MECA_TANG OU FULL_MECA)
! IN  IMATE   NATURE DU MATERIAU
! IN  EPSM    CHAMP DE DEFORMATION EN T-
! IN  DEPS    INCREMENT DU CHAMP DE DEFORMATION
! IN  VIM     VARIABLES INTERNES EN T-
!               1   : ENDOMMAGEMENT (D)
!               2   : INDICATEUR DISSIPATIF (1) OU ELASTIQUE (0)
! VAR VIP     VARIABLES INTERNES EN T+
!              IN  ESTIMATION (ITERATION PRECEDENTE)
!              OUT CALCULEES
! OUT SIGP    CONTRAINTES EN T+
! OUT DSIDEP  MATRICE TANGENTE
! OUT PROJ    PROJECTEUR DE COUPURE DU TERME DE REGULARISATION
! OUT IRET    CODE RETOUR (0 = OK)
! =====================================================================
    aster_logical :: rigi, resi, elas
    integer :: ndimsi, i, j, ndt, ndi
    real(kind=8) :: kron(6), tre, trer, valres(2), dsdp2(6, 6)
    real(kind=8) :: deuxmu, lambda, dsdp1b(6, 6), young, nu
    integer :: icodre(2)
    character(len=16) :: nomres(2)
! =====================================================================
    common /tdim/   ndt, ndi
! =====================================================================
    data kron   /1.d0, 1.d0, 1.d0, 0.d0, 0.d0, 0.d0/
    data nomres /'E','NU'/
! =====================================================================
! --- INITIALISATION --------------------------------------------------
! =====================================================================
    ndimsi = 2*ndim
    rigi = option(1:4).eq.'FULL' .or. option(1:4).eq.'RIGI'
    resi = option(1:4).eq.'FULL' .or. option(1:4).eq.'RAPH'
    elas = option(11:14).eq.'ELAS'
! =====================================================================
! --- CARACTERISTIQUES MATERIAU ---------------------------------------
! =====================================================================
    call rcvalb(fami, 1, 1, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                2, nomres, valres, icodre, 2)
    young = valres(1)
    nu = valres(2)
    deuxmu = young / ( 1.0d0 + nu )
    lambda = young * nu / ( 1.0d0 + nu ) / ( 1.0d0 - 2.d0 * nu )
! =====================================================================
! --- COMPORTEMENT LOCAL ----------------------------------------------
! =====================================================================
!
    call lcdrpr(fami, typmod, option, imate, compor, sigm,&
                deps(1, 2), vim,&
                vip, sig, dsdp2, iret)
! =====================================================================
! --- PROJECTEUR DE COUPURE POUR LA REGULARISATION : DEFAUT------------
! =====================================================================
    call r8inir(36, 0.d0, proj, 1)
    do i = 1, 6
        proj(i,i) = 1.d0
    end do
! =====================================================================
! --- CORRECTION NON LOCALE -------------------------------------------
! =====================================================================
    if (resi) then
        tre = deps(1,1)+deps(2,1)+deps(3,1)
        trer = deps(1,2)+deps(2,2)+deps(3,2)
!
        do i = 1, ndimsi
            sig(i) = sig(i) + lambda*(tre - trer)*kron(i) + deuxmu*( deps(i,1)-deps(i,2))
        end do
    endif
!
    if (rigi) then
!
        call lcinma(0.0d0, dsidep(1, 1, 1))
        call lcinma(0.0d0, dsdp1b)
        call lcinma(0.0d0, dsidep(1, 1, 2))
!
        do i = 1, 3
            do j = 1, 3
                dsidep(i,j,1) = lambda
            end do
        end do
!
        do i = 1, ndt
            dsidep(i,i,1) = dsidep(i,i,1) + deuxmu
        end do
!
        if (.not. elas) then
            call lcprsm(-1.0d0, dsidep(1, 1, 1), dsdp1b)
            call lcsoma(dsdp1b, dsdp2, dsidep(1, 1, 2))
        endif
    endif
! =====================================================================
end subroutine
