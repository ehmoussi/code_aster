! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine tanbul(option, ndim, g, mate, compor,&
                  resi, mini, alpha, dsbdep, trepst)
!
implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8miem.h"
#include "asterfort/epstmc.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
!
aster_logical :: resi, mini
integer :: ndim, g, mate
real(kind=8) :: alpha, dsbdep(2*ndim, 2*ndim), trepst
character(len=16) :: option, compor
!-----------------------------------------------------------------------
!          CALCUL DE LA MATRICE TANGENTE BULLE
!-----------------------------------------------------------------------
! IN  RESI    : CALCUL DES FORCES INTERNES
! IN  MINI    : STABILISATION BULLE - MINI ELEMENT
! IN  OPTION  : OPTION DE CALCUL
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  G       : NUMERO DU POINT DE GAUSS
! IN  MATE    : NUMERO DU MATERIAU
! IN  COMPOR  : NOM DU COMPORTEMENT
! OUT ALPHA   : INVERSE DE KAPPA
! OUT DSBDEP  : MATRICE TANGENTE BULLE
! OUT TREPST  : TRACE DU TENSEUR DES DEFORMATIONS THERMIQUES
!-----------------------------------------------------------------------
!
    integer :: k
    integer :: icodre(2), itemps, iret, iepsv
    real(kind=8) :: e, nu, valres(2), valpar
    real(kind=8) :: xyzgau(3), repere(7), epsth(6)
    real(kind=8) :: coef, coef1, coef2, coef3
    character(len=4) :: fami
    character(len=16) :: nomres(2)
    character(len=8) :: nompar
!-----------------------------------------------------------------------
!
!
! - INITIALISATION
    call r8inir(2*ndim*2*ndim, 0.d0, dsbdep, 1)
    call r8inir(3, 0.d0, xyzgau, 1)
    call r8inir(7, 0.d0, repere, 1)
    call r8inir(6, 0.d0, epsth, 1)
!
    nompar = 'INST'
    fami = 'RIGI'
!
! - LA FORMULATION INCO A 2 CHAMPS UP NE FONCTIONNE QU AVEC ELAS OU VMIS
! - POUR L INSTANT.
! - POUR L ANISOTROPIE IL FAUDRAIT CALCULER XYZGAU ET REPERE
    if (.not.( compor(1:4) .eq. 'ELAS'.or. compor(1:9) .eq. 'VMIS_ISOT' )) then
        call utmess('F', 'ELEMENTSINCO_1')
    endif
!
! - RECUPERATION DE L INSTANT
    call tecach('NNO', 'PTEMPSR', 'L', iret, iad=itemps)
    if (itemps .ne. 0) then
        valpar = zr(itemps)
    else
        valpar = 0.d0
    endif
!
! - RECUPERATION DE E ET NU DANS LE FICHIER PYTHON
    nomres(1)='E'
    nomres(2)='NU'
!
    call rcvalb('RIGI', g, 1, '+', mate,&
                ' ', 'ELAS', 1, nompar, [valpar],&
                2, nomres, valres, icodre, 1)
!
    e = valres(1)
    nu = valres(2)
    alpha=(3.d0*(1.d0-2.d0*nu))/e
!
    if (mini) then
        coef = 1.d0/((1.d0+nu)*(1.d0-2.d0*nu))
        coef1 = e*(1.d0-nu)*coef
        coef2 = e*nu*coef
        coef3 = 2.d0*e/(1.d0+nu)
!
        dsbdep(1,1) = coef1
        dsbdep(1,2) = coef2
        dsbdep(1,3) = coef2
!
        dsbdep(2,1) = coef2
        dsbdep(2,2) = coef1
        dsbdep(2,3) = coef2
!
        dsbdep(3,1) = coef2
        dsbdep(3,2) = coef2
        dsbdep(3,3) = coef1
!
        dsbdep(4,4) = coef3
        if (ndim .eq. 3) then
            dsbdep(5,5) = coef3
            dsbdep(6,6) = coef3
        endif
    endif
!
    if (resi) then
        call epstmc(fami, ndim, valpar, '+', g,&
                    1, xyzgau, repere, mate, option,&
                    epsth)
!
! - TEST DE LA NULLITE DES DEFORMATIONS DUES AUX VARIABLES DE COMMANDE
        iepsv = 0
        trepst = 0.d0
        do k = 1, 6
            if (abs(epsth(k)) .gt. r8miem()) iepsv=1
        end do
! - TOUTES DES COMPOSANTES SONT NULLES. ON EVITE DE CALCULER TREPST
        if (iepsv .ne. 0) then
            do k = 1, 3
                trepst = trepst + epsth(k)
            end do
        endif
    endif
!
end subroutine
