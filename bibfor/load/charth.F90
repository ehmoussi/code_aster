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

subroutine charth(load, vale_type)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/adalig.h"
#include "asterfort/caddli.h"
#include "asterfort/caechp.h"
#include "asterfort/cagene.h"
#include "asterfort/cagrou.h"
#include "asterfort/caliag.h"
#include "asterfort/caliai.h"
#include "asterfort/calich.h"
#include "asterfort/calirc.h"
#include "asterfort/cbconv.h"
#include "asterfort/cbecha.h"
#include "asterfort/cbflnl.h"
#include "asterfort/cbflux.h"
#include "asterfort/cbgrai.h"
#include "asterfort/cbprca.h"
#include "asterfort/cbrayo.h"
#include "asterfort/cbsonl.h"
#include "asterfort/cbsour.h"
#include "asterfort/cormgi.h"
#include "asterfort/initel.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/verif_affe.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=4), intent(in) :: vale_type
    character(len=8), intent(in) :: load
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Treatment of loads for AFFE_CHAR_THER_*
!
! --------------------------------------------------------------------------------------------------
!
!
! In  vale_type : affected value type (real, complex or function)
! In  load      : name of load
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_dim, iret
    character(len=8) :: mesh, model
    character(len=16) :: keywordfact, command
    character(len=19) :: ligrch, ligrmo
    character(len=8), pointer :: p_ligrch_lgrf(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
!
! - Mesh, Ligrel for model, dimension of model
!
    command = 'AFFE_CHAR_THER'
    call cagene(load, command, ligrmo, mesh, nb_dim)
    model  = ligrmo(1:8)
    if (nb_dim .gt. 3) then
        call utmess('A', 'CHARGES2_4')
    endif
!
! - Ligrel for loads
!
    ligrch = load//'.CHTH.LIGRE'
!
    if (vale_type .eq. 'REEL') then
!
! ----- SOURCE
!
        call cbsour(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- SOUR_NL
!
        call cbsonl(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- CONVECTION
!
        call cbconv(load)
!
! ----- FLUX_REP
!
        call cbflux(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- FLUX_NL
!
        call cbflnl(load, mesh, ligrmo, vale_type)
!
! ----- RAYONNEMENT
!
        call cbrayo(load, mesh, ligrmo, vale_type)
!
! ----- ECHANGE
!
        call cbecha(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- ECHANGE_PAROI
!
        call caechp(load, ligrch, ligrmo, mesh, vale_type, &
                    nb_dim)
!
! ----- EVOL_CHAR
!
        call cbprca('THERMIQUE', load)
!
! ----- GRADIENT INITIAL
!
        call cbgrai(load, mesh, ligrmo, vale_type)
!
! ----- TEMP_IMPO
!
        keywordfact = 'TEMP_IMPO'
        call caddli(keywordfact, load, mesh, ligrmo, vale_type)
!
! ----- LIAISON_DDL
!
        call caliai(vale_type, load, 'THER')
!
! ----- LIAISON_GROUP
!
        call caliag(vale_type, load, 'THER')
!
! ----- LIAISON_UNIF
!
        call cagrou(load, mesh, vale_type, 'THER')
!
! ----- LIAISON_CHAMNO
!
        call calich(load, 'THER')
!
! ----- LIAISON_MAIL
!
        call calirc('THERMIQUE', load, mesh)
!
    else if (vale_type .eq. 'FONC') then
!
! ----- SOURCE
!
        call cbsour(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- SOUR_NL
!
        call cbsonl(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- CONVECTION
!
        call cbconv(load)
!
! ----- FLUX_REP
!
        call cbflux(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- FLUX_NL
!
        call cbflnl(load, mesh, ligrmo, vale_type)
!
! ----- RAYONNEMENT
!
        call cbrayo(load, mesh, ligrmo, vale_type)
!
! ----- ECHANGE
!
        call cbecha(load, mesh, ligrmo, nb_dim, vale_type)
!
! ----- ECHANGE_PAROI
!
        call caechp(load, ligrch, ligrmo, mesh, vale_type,&
                    nb_dim)
!
! ----- GRADIENT INITIAL
!
        call cbgrai(load, mesh, ligrmo, vale_type)
!
! ----- TEMP_IMPO
!
        keywordfact = 'TEMP_IMPO'
        call caddli(keywordfact, load, mesh, ligrmo, vale_type)
!
! ----- LIAISON_DDL
!
        call caliai(vale_type, load, 'THER')
!
! ----- LIAISON_GROUP
!
        call caliag(vale_type, load, 'THER')
!
! ----- LIAISON_UNIF
!
        call cagrou(load, mesh, vale_type, 'THER')
    else
        ASSERT(.false.)
    endif
!
! - Update loads <LIGREL>
!
    call jeexin(ligrch//'.LGRF', iret)
    if (iret .ne. 0) then
        call adalig(ligrch)
        call cormgi('G', ligrch)
        call jeecra(ligrch//'.LGRF', 'DOCU', cval = 'THER')
        call initel(ligrch)
        call jeveuo(ligrch//'.LGRF', 'E', vk8 = p_ligrch_lgrf)
        p_ligrch_lgrf(2) = model
    endif
!
! - Audit assignments
!
    call verif_affe(modele=model,sd=load)
!
end subroutine
