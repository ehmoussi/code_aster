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

subroutine xdefco(mesh        , model, crack, algo_lagr, nb_dim,&
                  sdline_crack, tabai)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/xlagsp.h"
!
!
    integer, intent(in) :: nb_dim
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    character(len=8), intent(in)  :: crack
    integer, intent(in) :: algo_lagr
    character(len=14), intent(in) :: sdline_crack
    character(len=19) :: tabai
!
! --------------------------------------------------------------------------------------------------
!
! XFEM - Contact definition
!
! Lagrange multiplier space selection for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  mesh           : name of mesh
! In  crack          : name of crack 
! In  algo_lagr      : type of Lagrange multiplier space selection
! In  nb_dim         : dimension of space
! In  sdline_crack   : name of datastructure of linear relations for crack
! In/Out tabai       : (table) The 5th cmp of TOPOFAC.AI 
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_xfem, l_pilo, l_ainter
    integer :: ier
!
! --------------------------------------------------------------------------------------------------
!
    l_xfem = .false.
    l_pilo = .false.
    l_ainter = .true.
    call jeexin(crack//'.MAILFISS.HEAV', ier)
    if (ier .ne. 0) l_xfem=.true.
    call jeexin(crack//'.MAILFISS.CTIP', ier)
    if (ier .ne. 0) l_xfem=.true.
    call jeexin(crack//'.MAILFISS.HECT', ier)
    if (ier .ne. 0) l_xfem=.true.
    ASSERT(l_xfem)
!
    call xlagsp(mesh        , model, crack, algo_lagr, nb_dim,&
                sdline_crack, l_pilo, tabai, l_ainter)

end subroutine
