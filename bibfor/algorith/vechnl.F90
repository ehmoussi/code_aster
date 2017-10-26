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
!
subroutine vechnl(model    , lload_name, lload_info, time,&
                  temp_iter, vect_elem , base)
!
implicit none
!
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/gcnco2.h"
#include "asterfort/infniv.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecara.h"
#include "asterfort/megeom.h"
#include "asterfort/reajre.h"
#include "asterfort/wkvect.h"
#include "asterfort/inical.h"
#include "asterfort/load_list_info.h"
#include "asterfort/memare.h"
#include "asterfort/detrsd.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: lload_name
character(len=24), intent(in) :: lload_info
character(len=24), intent(in) :: time
character(len=24), intent(in) :: temp_iter
character(len=24), intent(in) :: vect_elem
character(len=1), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! Thermic - Residuals
! 
! Non-linear neumann loads elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  lload_name       : name of object for list of loads name
! In  lload_info       : name of object for list of loads info
! In  time             : time (<CARTE>)
! In  temp_iter        : temperature field at current Newton iteration
! In  vect_elem        : name of vect_elem result
! In  base             : JEVEUX base for object
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nbin  = 4
    integer , parameter :: nbout = 1
    character(len=8) :: lpain(nbin), lpaout(nbout)
    character(len=19) :: lchin(nbin), lchout(nbout)
    character(len=1) :: c1
    character(len=8) :: newnom, load_name
    character(len=16) :: option
    character(len=19) :: resu_elem
    character(len=24) :: ligrmo, chgeom
    integer :: iret, ibid, load_nume
    aster_logical :: load_empty
    integer :: i_load, nb_load
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resu_elem = '&&VECHTN.0000000'
    newnom    = '.0000000'
    ligrmo    = model(1:8)//'.MODELE'
!
! - Init fields
!
    call inical(nbin, lpain, lchin, nbout, lpaout, lchout)    
!
! - Loads
!
    call load_list_info(load_empty, nb_load   , v_load_name, v_load_info,&
                        lload_name, lload_info)
!
! - Prepare fields
!
    call megeom(model, chgeom)
!
! - Input fields
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom(1:19)
    lpain(2) = 'PTEMPSR'
    lchin(2) = time(1:19)
    lpain(3) = 'PTEMPER'
    lchin(3) = temp_iter(1:19)
!
! - Output fields
!
    lpaout(1) = 'PVECTTR'
!
! - Allocate result
!
    call detrsd('VECT_ELEM', vect_elem)
    call memare(base, vect_elem, model, ' ', ' ', 'CHAR_THER')
    call reajre(vect_elem, ' ', base)
!
! - Loop on loads
!
    if (nb_load .gt. 0) then
        do i_load = 1, nb_load
            load_name = v_load_name(i_load)(1:8)
            load_nume = v_load_info(nb_load+i_load+1)
! --------- For FLUX_NL
            lpain(4) = 'PFLUXNL'
            lchin(4) = load_name(1:8)//'.CHTH.FLUNL'
            call jeexin(lchin(4)//'.DESC', iret)
            if (iret .ne. 0) then
                option = 'CHAR_THER_FLUNL'
! ------------- Generate new RESU_ELEM name
                call gcnco2(newnom)
                resu_elem(10:16) = newnom(2:8)
                call corich('E', resu_elem, -1, ibid)
                lchout(1)        = resu_elem
! ------------- Compute
                call calcul('S'  , option, ligrmo, nbin  , lchin,&
                            lpain, nbout , lchout, lpaout, base ,&
                            'OUI')
! ------------- Save RESU_ELEM
                call reajre(vect_elem, resu_elem, base)
            endif
! --------- For RAYONNEMENT
            lchin(4) = load_name(1:8)//'.CHTH.RAYO '
            call jeexin(lchin(4)//'.DESC', iret)
            if (iret .ne. 0) then
                c1 = 'R'
                if (load_nume .gt. 1) then
                    c1 = 'F'
                endif
                option   = 'CHAR_THER_RAYO_'//c1
                lpain(4) = 'PRAYON'//c1
! ------------- Generate new RESU_ELEM name
                call gcnco2(newnom)
                resu_elem(10:16) = newnom(2:8)
                call corich('E', resu_elem, -1, ibid)
                lchout(1) = resu_elem
! ------------- Compute
                call calcul('S', option, ligrmo, nbin, lchin,&
                            lpain, nbout, lchout, lpaout, base,&
                            'OUI')
! ------------- Save RESU_ELEM
                call reajre(vect_elem, resu_elem, base)
            endif
! --------- For SOURCE_NL
            lpain(4) = 'PSOURNL'
            lchin(4) = load_name(1:8)//'.CHTH.SOUNL'
            call jeexin(lchin(4)//'.DESC', iret)
            if (iret .ne. 0) then
                option = 'CHAR_THER_SOURNL'
! ------------- Generate new RESU_ELEM name
                call gcnco2(newnom)
                resu_elem(10:16) = newnom(2:8)
                call corich('E', resu_elem, -1, ibid)
                lchout(1)        = resu_elem
! ------------- Compute
                call calcul('S'  , option, ligrmo, nbin  , lchin,&
                            lpain, nbout , lchout, lpaout, base ,&
                            'OUI')
! ------------- Save RESU_ELEM
                call reajre(vect_elem, resu_elem, base)
            endif
        end do
    endif
!
end subroutine
