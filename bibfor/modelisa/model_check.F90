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

subroutine model_check(model, l_veri_elem)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/modexi.h"
#include "asterfort/utmess.h"
#include "asterfort/taxis.h"
!
!
    character(len=8), intent(in) :: model
    aster_logical, optional, intent(in) :: l_veri_elem
!
! --------------------------------------------------------------------------------------------------
!
! Checking model
!
! --------------------------------------------------------------------------------------------------
!
! In  model        : name of the model
! In  l_veri_elem  : .true. if check jacobian (element quality)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_dim_geom, nb_dim_geom2, nb_dim_geom3
    character(len=16) :: repk
    integer :: i_disc_2d, i_disc_3d
    character(len=8) :: mesh
    aster_logical :: l_axis
    integer :: nb_mesh_elem
    character(len=19) :: ligrel_model
    character(len=24) :: model_maille
    integer, pointer :: p_model_maille(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nb_mesh_elem)
    call dismoi('AXIS', model, 'MODELE', repk = repk)
    l_axis = repk.eq.'OUI'
    call dismoi('DIM_GEOM', model, 'MODELE', repi = nb_dim_geom)
!
    ligrel_model = model//'.MODELE'
!
! - Check topoaster_logical dimensions
!
    if (nb_dim_geom .gt. 3) then
        nb_dim_geom2 = 0
        call utmess('A', 'MODELE1_14')
    else
        nb_dim_geom2=3
        nb_dim_geom3=3
        call dismoi('Z_CST', mesh, 'MAILLAGE', repk=repk)
        if (repk .eq. 'OUI') then
            nb_dim_geom2=2
            call dismoi('Z_ZERO', mesh, 'MAILLAGE', repk=repk)
            if (repk .eq. 'OUI') then
                nb_dim_geom3=2
            endif
        endif
!
        if ((nb_dim_geom.eq.3) .and. (nb_dim_geom2.eq.2)) then
!
! --------- Correct: shells elements with Z=Constant
!
        else if ((nb_dim_geom.eq.2) .and. (nb_dim_geom2.eq.3)) then
!
! --------- Warning: 2D model with 3D mesh
!
            call utmess('A', 'MODELE1_53')
            elseif ((nb_dim_geom.eq.2) .and. &
                (nb_dim_geom2.eq.2).and. &
                (nb_dim_geom3.eq.3)) then
!
! --------- Something strange: 2D with Z=Constant but Z<>0
!
            call utmess('A', 'MODELE1_58')
        endif
    endif
!
! - DISCRET elements: only 2D OR 3D
!
    call modexi(model, 'DIS_', i_disc_3d)
    call modexi(model, '2D_DIS_', i_disc_2d)
    if (nb_dim_geom2 .eq. 2 .and. i_disc_3d .eq. 1 .and. i_disc_2d .eq. 1) then
        call utmess('F', 'MODELE1_54')
    endif
!
! - Check if X>0 for axis elements
!
    if (l_axis) then
        model_maille = model//'.MAILLE'
        call jeveuo(model_maille, 'L', vi = p_model_maille)
        call taxis(mesh, p_model_maille, nb_mesh_elem)
    endif
!
! - ON VERIFIE QUE LA GEOMETRIE DES MAILLES N'EST PAS TROP CHAHUTEE
!
    if (present(l_veri_elem)) then
        if (l_veri_elem) then
            call calcul('C', 'VERI_JACOBIEN', ligrel_model, 1, mesh//'.COORDO',&
                        'PGEOMER', 1, '&&OP0018.CODRET', 'PCODRET', 'V',&
                        'OUI')
        endif
    endif
end subroutine
