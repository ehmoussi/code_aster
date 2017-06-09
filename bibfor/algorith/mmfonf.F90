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

subroutine mmfonf(ndim, nno, alias, ksi1, ksi2,&
                  ff, dff, ddff)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/mm2onf.h"
#include "asterfort/mmdonf.h"
#include "asterfort/mmnonf.h"
    character(len=8) :: alias
    real(kind=8) :: ksi1, ksi2
    real(kind=8) :: ff(9)
    real(kind=8) :: dff(2, 9)
    real(kind=8) :: ddff(3, 9)
    integer :: nno, ndim
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES EN UN POINT
! DE L'ELEMENT DE REFERENCE
!
! ----------------------------------------------------------------------
!
!
! ROUTINE "GLUTE" NECESSAIRE DU FAIT QUE LES FCT. FORME DE LA METHODE
! CONTINUE NE SONT PAS CELLES STANDARDS D'ASTER.
!
!
! IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
! IN  NNO    : NOMBRE DE NOEUD DE L'ELEMENT
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! IN  KSI1   : POINT DE CONTACT SUIVANT KSI1 DES
!               FONCTIONS DE FORME ET LEURS DERIVEES
! IN  KSI2   : POINT DE CONTACT SUIVANT KSI2 DES
!               FONCTIONS DE FORME ET LEURS DERIVEES
! OUT FF     : FONCTIONS DE FORMES EN XI,YI
! OUT DFF    : DERIVEES PREMIERES DES FONCTIONS DE FORME EN XI YI
! OUT DDFF   : DERIVEES SECONDES DES FONCTIONS DE FORME EN XI YI
!
! ----------------------------------------------------------------------
!
!
!
    call mmnonf(ndim, nno, alias, ksi1, ksi2,&
                ff)
!
    call mmdonf(ndim, nno, alias, ksi1, ksi2,&
                dff)
!
    call mm2onf(ndim, nno, alias, ksi1, ksi2,&
                ddff)
!
end subroutine
