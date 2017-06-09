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

subroutine mmmtdb(valr, typmat, ii, jj)
!
!
    implicit none
    real(kind=8) :: valr
    character(len=2) :: typmat
    integer :: ii, jj
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! ROUTINE DE DEBUGGAGE POUR LES TE
!
! ----------------------------------------------------------------------
!
!
! IN  VALR   : VALEUR DE LA COMPOSANTE DANS LA MATRICE
! IN  II     : LIGNE DE LA MATRICE
! IN  JJ     : COLONNE DE LA MATRICE
! IN  TYPMAT : TYPE DE MATRICE PONCTUELLE
!                'XY' AVEC
!                E  - ESCLAVE
!                M  - MAITRE
!                C  - CONTACT
!                F  - FROTTEMENT
!                IJ - MATR_ELEM
!
! ----------------------------------------------------------------------
!
    if (valr .ne. 0.d0) then
        write(6,*) 'MATR-ELEM-'//typmat,'(',ii,',',jj,'): ',valr
    endif
!
end subroutine
