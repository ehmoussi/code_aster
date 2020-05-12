! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine umalma(mesh, list_grpma, nb_grpma, list_ma, nb_ma)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
!
    character(len=8), intent(in) :: mesh
    character(len=24), intent(in) :: list_grpma(*)
    integer, intent(in) :: nb_grpma
    integer, pointer :: list_ma(:)
    integer, intent(out) :: nb_ma
!     ------------------------------------------------------------------
!
!     Etablir la liste (sans doublons) des mailles d’une liste de
!     GROUP_MA
!     ------------------------------------------------------------------
! In list_grpma  : liste des groupes de mailles
! In nb_grpma    : nombre de groupes de mailles
! Out list_ma    : liste des mailles des groupes de mailles
! Out nb_ma      : nombre de mailles
!     ------------------------------------------------------------------
!
    integer :: nbma, nbmatot, igr, iret, ima, jma
    character(len=24) :: mlggma, grpma
    integer, pointer :: v_lma(:) => null(), v_allma(:) => null()
    aster_logical :: l_keep
!-----------------------------------------------------------------------
    nb_ma = 0
    mlggma = mesh//'.GROUPEMA'
!
    if (nb_grpma > 0) then
!
! --- Get number of cells
!
        nbmatot = 0
        do igr = 1, nb_grpma
            grpma = list_grpma(igr)
            call jeexin(jexnom(mlggma, grpma), iret)
            if (iret .ne. 0) then
                call jelira(jexnom(mlggma, grpma), 'LONUTI', nbma)
                if (nbma .ne. 0) then
                    nbmatot = nbmatot + nbma
                endif
            endif
        end do
!
! --- Get list of cells
!
        AS_ALLOCATE(vi=v_allma, size=nbmatot)
        nbmatot = 0
        do igr = 1, nb_grpma
            grpma = list_grpma(igr)
            call jeexin(jexnom(mlggma, grpma), iret)
            if (iret .ne. 0) then
                call jelira(jexnom(mlggma, grpma), 'LONUTI', nbma)
                if (nbma .ne. 0) then
                    call jeveuo(jexnom(mlggma, grpma), 'L', vi=v_lma)
                    do ima = 1, nbma
                        v_allma(nbmatot+ima) = v_lma(ima)
                    end do
                    nbmatot = nbmatot + nbma
                endif
            endif
        end do
!
! --- Remove duplicate cell
!
        nb_ma = 0
        do ima = 1, nbmatot
            l_keep = ASTER_TRUE
            do jma = 1, ima - 1
                if(v_allma(ima) == v_allma(jma)) then
                    l_keep = ASTER_FALSE
                    exit
                end if
            end do
!
            if(l_keep) then
                nb_ma = nb_ma + 1
                v_allma(nb_ma) = v_allma(ima)
            end if
        end do
!
        AS_ALLOCATE(vi=list_ma, size=nb_ma)
        list_ma(1:nb_ma) = v_allma(1:nb_ma)
!
        AS_DEALLOCATE(vi=v_allma)
!
    endif
!
end subroutine
