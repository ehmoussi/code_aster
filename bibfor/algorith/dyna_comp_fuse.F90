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

subroutine dyna_comp_fuse(mesh, comp_noli, comp_fuse)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_elas.h"
#include "asterfort/comp_init.h"
#include "asterfort/carces.h"
#include "asterfort/cescar.h"
#include "asterfort/cesfus.h"
#include "asterfort/detrsd.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: comp_noli
    character(len=19), intent(in) :: comp_fuse
!
! --------------------------------------------------------------------------------------------------
!
! DYNA_VIBRA//HARM/GENE
!
! Fuse COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh : name of mesh
! In  comp_noli : name of NOLI COMPOR <CARTE>
! In  comp_fuse : name of fuse of NOLI COMPOR <CARTE> and ELAS COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nc
    parameter (nc = 2)
    character(len=19) :: chs(nc)
    aster_logical :: l_cumu(nc)
    real(kind = 8) :: coef_real(nc)
    complex(kind = 8) :: coef_cplx(nc)
!
    integer :: ibid, nb_cmp
    character(len=19) :: comp_elas
    character(len=19) :: comp_elas_s, comp_noli_s, comp_fuse_s
    aster_logical :: l_cplx, l_etat_init
!
    data l_cumu      /.false._1,.false./
    data coef_real   /1.d0, 1.d0/
!
! --------------------------------------------------------------------------------------------------
!
    comp_elas = '&&DYNA_COMP_ELAS'
    comp_elas_s = '&&DYNA_COMP_ELAS_S'
    comp_noli_s = '&&DYNA_COMP_NOLI_S'
    comp_fuse_s = '&&DYNA_COMP_FUSE_S'
    l_cplx = .false.
    l_etat_init = .false.
!
! - Create ELAS COMPOR <CARTE>
!
    call comp_init(mesh, comp_elas, 'V', nb_cmp)
    call comp_meca_elas(comp_elas, nb_cmp, l_etat_init)
!
! - Transform ELAS COMPOR <CARTE> in <CHAM_ELEM_S>
!
    call carces(comp_elas, 'ELEM', ' ', 'V', comp_elas_s,&
                'A', ibid)
!
! - Transform NOLI COMPOR <CARTE> in <CHAM_ELEM_S>
!
    call carces(comp_noli, 'ELEM', ' ', 'V', comp_noli_s,&
                'A', ibid)
!
! - Fuse the <CARTE>
!
    chs(1) = comp_elas_s
    chs(2) = comp_noli_s
    call cesfus(nc, chs, l_cumu, coef_real, coef_cplx,&
                l_cplx, 'V', comp_fuse_s)
!
! - Transform in <CARTE>
!
    call cescar(comp_fuse_s, comp_fuse, 'G')
!
    call detrsd('CHAMP', comp_elas)
    call detrsd('CHAMP', comp_elas_s)
    call detrsd('CHAMP', comp_fuse_s)
    call detrsd('CHAMP', comp_noli_s)
!
end subroutine
