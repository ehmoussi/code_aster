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

subroutine apcinv(mesh, sdappa, i_zone)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cncinv.h"
#include "asterfort/cnvois.h"
#include "asterfort/codent.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/gt_linoma.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_info.h"

#ifdef _USE_MPI
#include "mpif.h"
#include "asterf_mpi.h"
#endif
!
!
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: sdappa
    integer, intent(in) :: i_zone
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Create objects for inverse connectivity
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sdappa           : name of pairing datastructure
! In  i_zone           : index of contact zone
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: knuzo
    character(len=24) :: cnives
    integer :: nb_elem_mast, nb_elem_slav, nb_node_mast
    character(len=24) :: sdappa_mast, sdappa_slav 
    character(len=24) :: sdappa_slne, sdappa_mane, sdappa_civm, sdappa_lnma
    integer :: mast_indx_maxi , slav_indx_maxi, mast_indx_mini, slav_indx_mini
    integer, pointer :: v_sdappa_mast(:) => null()
    integer, pointer :: v_sdappa_slav(:) => null()
    mpi_int :: i_proc, nb_proc, mpicou
    integer :: nb_elem_mpi, nbr_elem_mpi, idx_start, idx_end
    integer, pointer :: v_appa_slav_mpi(:) => null()
    integer ::nb_el_slav_mpi
    integer, pointer :: list_node_mast(:) => null()
    integer, pointer :: v_lnma(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Generate name of objects
!
    ASSERT(i_zone .le. 100)
    call codent(i_zone-1, 'G', knuzo)
    sdappa_mane = sdappa(1:19)//'.MN'//knuzo(1:2)
    sdappa_slne = sdappa(1:19)//'.EN'//knuzo(1:2)
    sdappa_mast = sdappa(1:19)//'.MS'//knuzo(1:2)
    sdappa_slav = sdappa(1:19)//'.EC'//knuzo(1:2)
    sdappa_civm = sdappa(1:19)//'.CM'//knuzo(1:2)
    sdappa_lnma = sdappa(1:19)//'.LM'//knuzo(1:2)
!
! - Access to objects
!
    call jelira(sdappa_mast, 'LONMAX', nb_elem_mast)
    call jelira(sdappa_slav, 'LONMAX', nb_elem_slav) 
    call jeveuo(sdappa_mast, 'L', vi = v_sdappa_mast)
    call jeveuo(sdappa_slav, 'L', vi = v_sdappa_slav)
!
! - Create list of node of master elements
!
    call gt_linoma(mesh,v_sdappa_mast,nb_elem_mast,list_node_mast,nb_node_mast)
    call wkvect(sdappa_lnma,'V V I',nb_node_mast ,vi=v_lnma)
    v_lnma(:)=list_node_mast(:)
    AS_DEALLOCATE(vi=list_node_mast)
!
! - Get parameters
!
    mast_indx_maxi = maxval(v_sdappa_mast)
    mast_indx_mini = minval(v_sdappa_mast)
!
! - Create inverse connectivities
!
    cnives = '&&aplcpg_cnives'
!
! - MPI initialisation
! 
    call asmpi_comm('GET', mpicou)
    call asmpi_info(mpicou,rank=i_proc , size=nb_proc)
    nb_elem_mpi  = int(nb_elem_slav/nb_proc)
    nbr_elem_mpi = nb_elem_slav-nb_elem_mpi*nb_proc
    idx_start    = 1+(i_proc)*nb_elem_mpi
    idx_end      = idx_start+nb_elem_mpi-1+nbr_elem_mpi*int((i_proc+1)/nb_proc)
    nb_el_slav_mpi = idx_end - idx_start + 1 
    AS_ALLOCATE(vi=v_appa_slav_mpi, size=nb_el_slav_mpi)
    v_appa_slav_mpi(:)=v_sdappa_slav(idx_start:idx_end)
    slav_indx_maxi = maxval(v_appa_slav_mpi)
    slav_indx_mini = minval(v_appa_slav_mpi)
    !write(*,*)"I_PROC = ", i_proc
    !write(*,*)"NB_ELEM_MPI = ",nb_el_slav_mpi, "LIST_ELEM_SLAV_MPI = ",v_appa_slav_mpi(:)
    !write(*,*)"NB_ELEM_SLAV = ", nb_elem_slav, "LIST_ELEM_SLAV = ",v_sdappa_slav(:)
    call cncinv(mesh, v_appa_slav_mpi, nb_el_slav_mpi, 'V', cnives)
    call cncinv(mesh, v_sdappa_mast, nb_elem_mast, 'V', sdappa_civm)
!
! - Create neighbouring objects
!
    call jedetr(sdappa_slne)
    call jedetr(sdappa_mane) 
    call cnvois(mesh  , v_appa_slav_mpi, nb_el_slav_mpi, slav_indx_mini, slav_indx_maxi,&
                cnives, sdappa_slne)
    call cnvois(mesh       , v_sdappa_mast, nb_elem_mast, mast_indx_mini, mast_indx_maxi,&
                sdappa_civm, sdappa_mane)
    AS_DEALLOCATE(vi=v_appa_slav_mpi)
!
! - Cleaning
!
    call jedetr(cnives)
!
end subroutine        
