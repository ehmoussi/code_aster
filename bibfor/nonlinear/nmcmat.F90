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

subroutine nmcmat(matr_type_ , calc_opti_    , asse_opti_    , l_calc        , l_asse     ,&
                  nb_matr    , list_matr_type, list_calc_opti, list_asse_opti, list_l_calc,&
                  list_l_asse)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: matr_type_
    character(len=*), intent(in) :: calc_opti_    
    character(len=*), intent(in) :: asse_opti_
    aster_logical, intent(in) :: l_calc
    aster_logical, intent(in) :: l_asse
    integer, intent(inout) :: nb_matr
    character(len=6), intent(inout)  :: list_matr_type(20)
    character(len=16), intent(inout) :: list_calc_opti(20) 
    character(len=16), intent(inout) :: list_asse_opti(20)
    aster_logical, intent(inout) :: list_l_asse(20)
    aster_logical, intent(inout) :: list_l_calc(20)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Computation
!
! Mangement of list of matrix to compute/assembly
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  matr_type        : type of matrix
!                MERIGI  - MATRICE POUR RIGIDITE
!                MEDIRI  - MATRICE POUR CL DIRICHLET LAGRANGE
!                MEGEOM  - MATRICE POUR NON-LIN. GEOMETRIQUE
!                MEAMOR  - MATRICE POUR AMORTISSEMENT
!                MEMASS  - MATRICE POUR MASSE
!                MESUIV  - MATRICE POUR CHARGEMENT SUIVEUR
!                MESSTR  - MATRICE POUR SOUS-STRUCTURES
!                MECTCC  - MATRICE POUR CONTACT CONTINU
!                MECTCF  - MATRICE POUR FROTTEMENT CONTINU
!                MEXFEC  - MATRICE POUR CONTACT XFEM
!                MEXFEF  - MATRICE POUR FROTTEMENT XFEM
!                MEXFTC  - MATRICE POUR CONTACT XFEM (GRD GLIS)
!                MEXFTF  - MATRICE POUR FROTT. XFEM (GRD GLIS)
! In  calc_opti        : option for matr_elem
! In  asse_opti        : option for matr_asse
! In  l_calc           : .true. to compute matr_elem
! In  l_asse           : .true. to assembly matr_elem in matr_asse
! IO  nb_matr          : number of matrix in list
! IO  list_matr_type   : list of matrix
! IO  list_calc_opti   : list of options for matr_elem
! IO  list_asse_opti   : list of options for matr_asse
! IO  list_l_calc      : list of flags to compute matr_elem
! IO  list_l_asse      : list of flags to assembly matr_elem in matr_asse
!
! --------------------------------------------------------------------------------------------------
!
    nb_matr = nb_matr + 1
    ASSERT(nb_matr.le.20)
    list_matr_type(nb_matr) = matr_type_
    list_calc_opti(nb_matr) = calc_opti_
    list_asse_opti(nb_matr) = asse_opti_
    list_l_asse(nb_matr)    = l_asse
    list_l_calc(nb_matr)    = l_calc
!
end subroutine
