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

#ifndef THREADING_INTERFACES_H
#define THREADING_INTERFACES_H
! personne_in_charge: mathieu.courtois@edf.fr
!
interface
#ifdef _USE_OPENMP
    subroutine omp_set_num_threads(a)
        integer, intent(in) :: a
    end subroutine

    function omp_get_max_threads()
        integer :: omp_get_max_threads
    end function

    function omp_get_thread_num()
        integer :: omp_get_thread_num
    end function
#endif

#ifdef _USE_OPENBLAS
    subroutine openblas_set_num_threads(a)
        integer, intent(in) :: a
    end subroutine
#endif

#ifdef _USE_MKL
    subroutine mkl_set_num_threads(a)
        integer, intent(in) :: a
    end subroutine
#endif

end interface
#endif
