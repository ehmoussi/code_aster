! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
module HHO_size_module
!
use HHO_type
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/binomial.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Define size function that are shared by the different modules
! Include astefort/HHO_size_module.h to define the sizes of different table
!
! --------------------------------------------------------------------------------------------------
!
!
    public :: hhoTherDofs, hhoTherNLDofs, hhoMecaDofs, hhoMecaNLDofs, hhoMecaGradDofs
    public :: hhoTherFaceDofs, hhoMecaFaceDofs, hhoTherCellDofs, hhoMecaCellDofs
    public :: hhoContactDofs
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoTherDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        integer, intent(out)                :: cbs
        integer, intent(out)                :: fbs
        integer, intent(out)                :: total_dofs
!
! --------------------------------------------------------------------------------------------------
!   HHO - thermics
!
!   Compute the number of dofs for thermics
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   Out cbs         : number of cell dofs
!   Out fbs         : number of face dofs
!   Out total_dofs  : number of total dofs
!
! --------------------------------------------------------------------------------------------------
!
! ---- number of dofs
        call hhoTherCellDofs(hhoCell, hhoData, cbs)
        call hhoTherFaceDofs(hhoCell%faces(1), hhoData, fbs)
        total_dofs = cbs + hhoCell%nbfaces * fbs
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoTherNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        integer, intent(out)                :: cbs
        integer, intent(out)                :: fbs
        integer, intent(out)                :: total_dofs
        integer, intent(out)                :: gbs
!
! --------------------------------------------------------------------------------------------------
!   HHO - thermics
!
!   Compute the number of dofs for non-linear thermics
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   Out cbs         : number of cell dofs
!   Out fbs         : number of face dofs
!   Out total_dofs  : number of total dofs
!   Out gbs         : number of gradient dofs
!
! --------------------------------------------------------------------------------------------------
!
        integer :: ndim
! --------------------------------------------------------------------------------------------------
!
        ndim = hhoCell%ndim
!
! ---- number of dofs
!
        call hhoTherDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        gbs = ndim * binomial(hhoData%grad_degree() + ndim, hhoData%grad_degree())
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        integer, intent(out)                :: cbs
        integer, intent(out)                :: fbs
        integer, intent(out)                :: total_dofs
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the number of dofs for mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   Out cbs         : number of cell dofs
!   Out fbs         : number of face dofs
!   Out total_dofs  : number of total dofs
!
! --------------------------------------------------------------------------------------------------
!
        integer :: ndim
! --------------------------------------------------------------------------------------------------
!
        ndim = hhoCell%ndim
!
! ---- number of dofs
!
        call hhoMecaCellDofs(hhoCell, hhoData, cbs)
        call hhoMecaFaceDofs(hhoCell%faces(1), hhoData, fbs)
        total_dofs = cbs + hhoCell%nbfaces * fbs
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        integer, intent(out)                :: cbs
        integer, intent(out)                :: fbs
        integer, intent(out)                :: total_dofs
        integer, intent(out)                :: gbs
        integer, intent(out)                :: gbs_sym
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the number of dofs for non-linear mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   Out cbs         : number of cell dofs
!   Out fbs         : number of face dofs
!   Out total_dofs  : number of total dofs
!   Out gbs         : number of gradient dofs
!   Out gbs_sym     : number of symmetric gradient dofs
! --------------------------------------------------------------------------------------------------
!
        integer :: ndim, gbs_comp
! --------------------------------------------------------------------------------------------------
!
        ndim = hhoCell%ndim
        gbs_comp = binomial(hhoData%grad_degree() + ndim, hhoData%grad_degree())
! ---- number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        call hhoMecaGradDofs(hhoCell, hhoData, gbs, gbs_sym)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoTherFaceDofs(hhoFace, hhoData, fbs)
!
    implicit none
!
        type(HHO_Face), intent(in)  :: hhoFace
        type(HHO_Data), intent(in)  :: hhoData
        integer, intent(out)        :: fbs
!
! --------------------------------------------------------------------------------------------------
!   HHO - thermic
!
!   Compute the number of dofs for thermic
!   In hhoFace      : the current HHO Face
!   In hhoData      : information on HHO methods
!   Out fbs         : number of face dofs
!
! --------------------------------------------------------------------------------------------------
!
        fbs =  binomial(hhoData%face_degree() + hhoFace%ndim, hhoData%face_degree())
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaFaceDofs(hhoFace, hhoData, fbs)
!
    implicit none
!
        type(HHO_Face), intent(in)  :: hhoFace
        type(HHO_Data), intent(in)  :: hhoData
        integer, intent(out)        :: fbs
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the number of dofs for mechanics
!   In hhoFace      : the current HHO Face
!   In hhoData      : information on HHO methods
!   Out fbs         : number of face dofs
!
! --------------------------------------------------------------------------------------------------
!
        integer :: fbs_ther
! --------------------------------------------------------------------------------------------------
!
        call hhoTherFaceDofs(hhoFace, hhoData, fbs_ther)
        fbs = (hhoFace%ndim + 1) * fbs_ther
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoTherCellDofs(hhoCell, hhoData, cbs)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        integer, intent(out)        :: cbs
!
! --------------------------------------------------------------------------------------------------
!   HHO - thermic
!
!   Compute the number of dofs for thermic
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   Out cbs         : number of cell dofs
!
! --------------------------------------------------------------------------------------------------
!
        cbs =  binomial(hhoData%cell_degree() + hhoCell%ndim, hhoData%cell_degree())
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaCellDofs(hhoCell, hhoData, cbs)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        integer, intent(out)        :: cbs
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the number of dofs for mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   Out cbs         : number of cell dofs
!
! --------------------------------------------------------------------------------------------------
!
        integer :: cbs_ther
! --------------------------------------------------------------------------------------------------
!
        call hhoTherCellDofs(hhoCell, hhoData, cbs_ther)
        cbs = hhoCell%ndim * cbs_ther
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaGradDofs(hhoCell, hhoData, gbs, gbs_sym)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        integer, intent(out)        :: gbs
        integer, intent(out)        :: gbs_sym
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the number of dofs for mechanics
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   Out gbs         : number of grad dofs
!   Out gbs_sym     : number of symmetric grad dofs
!
! --------------------------------------------------------------------------------------------------
!
        integer :: gbs_comp, ndim
! --------------------------------------------------------------------------------------------------
!
        ndim = hhoCell%ndim
        gbs_comp = binomial(hhoData%grad_degree() + ndim, hhoData%grad_degree())
!
        gbs = ndim * ndim * gbs_comp
!
        if(ndim == 3) then
            gbs_sym = 6 * gbs_comp
        else if(ndim == 2) then
            gbs_sym = 3 * gbs_comp
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoContactDofs(hhoCellSlav, hhoDataSlav, hhoFaceMast, hhoDataMast, &
                              cbsSlav, fbsSlav, total_fbsSlav, fbsMast, &
                              total_cont_dofs, total_face_dofs)
!
    implicit none
!
        type(HHO_Cell), intent(in)    :: hhoCellSlav
        type(HHO_Data), intent(in)    :: hhoDataSlav
        type(HHO_Face), intent(in)    :: hhoFaceMast
        type(HHO_Data), intent(in)    :: hhoDataMast
        integer, intent(out)          :: cbsSlav
        integer, intent(out)          :: fbsSlav
        integer, intent(out)          :: total_fbsSlav
        integer, intent(out)          :: fbsMast
        integer, intent(out)          :: total_cont_dofs
        integer, intent(out)          :: total_face_dofs
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the number of dofs for non-linear mechanics
!   In hhoCellSlav      : the current HHO Cell (Slave side)
!   In hhoDataSlav      : information on HHO methods (Slave side)
!   In hhoFaceMast      : the current HHO Face (Master side)
!   In hhoDataMast      : information on HHO methods (Master side)
!   Out cbsSlav         : number of cell dofs (Slave side)
!   Out fbsSlav         : number of face dofs (Slave side)
!   Out total_fbsSlav   : number of total faces dofs (Slave side)
!   Out fbsMast         : number of face dofs (Master side)
!   Out total_cont_dofs : number of total dofs (faces + cell)
!   Out total_face_dofs : number of total faces dofs
! --------------------------------------------------------------------------------------------------
!
        integer :: total_dofs_Slav
! --------------------------------------------------------------------------------------------------
!
! ---- number of dofs
        call hhoMecaDofs(hhoCellSlav, hhoDataSlav, cbsSlav, fbsSlav, total_dofs_Slav)
        call hhoMecaFaceDofs(hhoFaceMast, hhoDataMast, fbsMast)
!
        total_fbsSlav   = total_dofs_Slav - cbsSlav
        total_cont_dofs = total_dofs_Slav + fbsMast
        total_face_dofs = total_fbsSlav + fbsMast
!
    end subroutine
!
end module
