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

function num_rank_mat33(m, prec, indic)
!
      implicit none
#include "asterc/r8prem.h"
#include "asterfort/cubic_root.h"
#include "asterfort/det_mat.h"
#include "asterfort/norm_mat.h"
#include "asterfort/mat_com.h"
#include "asterfort/trace_mat.h"
!
      integer :: num_rank_mat33
      real(kind=8), intent(in) :: m(3,3)
      real(kind=8), intent(in) :: prec
      real(kind=8), intent(out) :: indic
!
!
!     RANG D UNE MATRICE DE TAILLE 3*3
!
! IN  M  : MATRICE DE TAILLE 3*3
! IN PREC : PRECISION EN DECA DE LAQUELLE ON CONSIDERE
!           QUE LA MATRICE EST SINGULIERE
! OUT INDIC : ESTIMATION DU CONDITIONNEMENT
!
      integer :: ndim
      real(kind=8) :: det_m, norm_m, com_m(3,3), sec_inv
!
      ndim = 3
      indic = 0.d0
      det_m = det_mat(ndim, m)
      norm_m = norm_mat(ndim, m)
      if(norm_m.eq.0.d0) then
          num_rank_mat33 = 0
      else if(cubic_root(abs(det_m)).le.prec*norm_m) then
          com_m = mat_com(ndim, m)
          sec_inv = trace_mat(ndim, com_m)
          if(sqrt(abs(sec_inv)).le.prec*norm_m) then
              num_rank_mat33 = 1
          else
              num_rank_mat33 = 2
          endif
      else
          num_rank_mat33 = 3
      endif
!
      if(det_m.ne.0.d0) then
          indic = norm_m/cubic_root(abs(det_m))
      endif
!
end function
