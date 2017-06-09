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

subroutine mmform(ndim, nommae, nommam, nne, nnm,&
                  xpc, ypc, xpr, ypr, ffe,&
                  dffe, ddffe, ffm, dffm, ddffm,&
                  ffl, dffl, ddffl)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/mmfonf.h"
    character(len=8) :: nommae, nommam
    real(kind=8) :: xpc, ypc, xpr, ypr
    integer :: ndim, nne, nnm
    real(kind=8) :: ffe(9), dffe(2, 9), ddffe(3, 9)
    real(kind=8) :: ffm(9), dffm(2, 9), ddffm(3, 9)
    real(kind=8) :: ffl(9), dffl(2, 9), ddffl(3, 9)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES EN UN POINT
! DE L'ELEMENT DE REFERENCE
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DU MODELE
! IN  NOMMAE : NOM DE LA MAILLE ESCLAVE
! IN  NOMMAM : NOM DE LA MAILLE MAITRE
! IN  XPC    : POINT DE CONTACT SUIVANT KSI1
! IN  YPC    : POINT DE CONTACT SUIVANT KSI2
! IN  XPR    : PROJECTION DU POINT DE CONTACT SUIVANT KSI1
! IN  YPR    : PROJECTION DU POINT DE CONTACT SUIVANT KSI2
! OUT FFE    : FONCTIONS DE FORMES ESCLAVES
! OUT DFFE   : DERIVEES PREMIERES DES FONCTIONS DE FORME ESCLAVES
! OUT DDFFE  : DERIVEES SECONDES DES FONCTIONS DE FORME ESCLAVES
! OUT FFM    : FONCTIONS DE FORMES MAITRES
! OUT DFFM   : DERIVEES PREMIERES DES FONCTIONS DE FORME MAITRES
! OUT DDFFM  : DERIVEES SECONDES DES FONCTIONS DE FORME MAITRES
! OUT FFL    : FONCTIONS DE FORMES LAGR.
! OUT DFFL   : DERIVEES PREMIERES DES FONCTIONS DE FORME LAGR.
! OUT DDFFL  : DERIVEES SECONDES DES FONCTIONS DE FORME LAGR.
!
! ----------------------------------------------------------------------
!
    integer :: i
!
! ----------------------------------------------------------------------
!
!
! --- FONCTIONS DE FORMES ET DERIVEES POUR LES DDL ESCLAVES
!
    call mmfonf(ndim, nne, nommae, xpc, ypc,&
                ffe, dffe, ddffe)
!
! --- FONCTIONS DE FORMES ET DERIVEES POUR LES DDL MAITRES
!
    call mmfonf(ndim, nnm, nommam, xpr, ypr,&
                ffm, dffm, ddffm)
!
! --- FONCTIONS DE FORMES ET DERIVEES POUR LES DDL DE LAGRANGE
!
    do 10 i = 1, 9
        ffl(i) = ffe(i)
        dffl(1,i) = dffe(1,i)
        dffl(2,i) = dffe(2,i)
        ddffl(1,i) = ddffe(1,i)
        ddffl(2,i) = ddffe(2,i)
        ddffl(3,i) = ddffe(3,i)
10  end do
!
end subroutine
