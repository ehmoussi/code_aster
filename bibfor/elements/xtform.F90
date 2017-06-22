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

subroutine xtform(ndim, typmae, typmam, typmac, nne,&
                  nnm, nnc, coore, coorm, coorc,&
                  ffe, ffm, dffc)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/elrfdf.h"
#include "asterfort/elrfvf.h"
    character(len=8) :: typmae, typmam, typmac
    real(kind=8) :: coorc(2), coore(3), coorm(3)
    integer :: ndim, nnm, nnc, nne
    real(kind=8) :: ffe(20)
    real(kind=8) :: ffm(20)
    real(kind=8) :: dffc(3, 9)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DU MODELE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  NNC    : NOMBRE DE NOEUDS DE LA MAILLE DE CONTACT
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  TYPMAE : TYPE DE LA MAILLE ESCLAVE
! IN  TYPMAM : TYPE DE LA MAILLE MAITRE
! IN  TYPMAC : TYPE DE LA MAILLE DE CONTACT
! IN  COORC  : COORDONNEES DU POINT DE CONTACT
! IN  COORE  : LES COORDONNEES ESCLAVES DANS L'ELEMENT PARENT
! IN  COORM  : LES COORDONNEES MAITRES DANS L'ELEMENT PARENT
! OUT FFE    : FONCTIONS DE FORMES ESCLAVES
! OUT FFM    : FONCTIONS DE FORMES MAITRES
! OUT DFFC   : DERIVEES PREMIERES DES FONCTIONS DE FORME LAGR. CONTACT
!
! ----------------------------------------------------------------------
!
    integer :: ibid
!
! ----------------------------------------------------------------------
!
!
! --- DERIVEES DES FONCTIONS DE FORMES POUR LE PT DE CONTACT DANS
! --- L'ELEMENT DE CONTACT
!
    call elrfdf(typmac, coorc, nnc*ndim, dffc, ibid,&
                ibid)
!
! --- FONCTIONS DE FORMES DU POINTS DE CONTACT DANS L'ELEMENT PARENT
!
    call elrfvf(typmae, coore, nne, ffe, nne)
!
! --- FONCTIONS DE FORMES DE LA PROJ DU PT DE CONTACT DANS L'ELE PARENT
!
    if (nnm .ne. 0) call elrfvf(typmam, coorm, nnm, ffm, nnm)
!
!
end subroutine
