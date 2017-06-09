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

subroutine vedime(model     , lload_name, lload_info, time, typres,&
                  vect_elemz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/inical.h"
#include "asterfort/load_list_info.h"
#include "asterfort/detrsd.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/megeom.h"
#include "asterfort/mecact.h"
#include "asterfort/gcnco2.h"
#include "asterfort/corich.h"
#include "asterfort/calcul.h"
!
!
    character(len=24), intent(in) :: model
    character(len=24), intent(in) :: lload_name
    character(len=24), intent(in) :: lload_info
    real(kind=8), intent(in) :: time
    character(len=*), intent(in) :: typres
    character(len=*), intent(inout) :: vect_elemz
!
! --------------------------------------------------------------------------------------------------
!
! Compute Dirichlet loads
!
! For Lagrange elements (AFFE_CHAR_MECA) - U(given)
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  lload_name     : name of object for list of loads name
! In  lload_info     : name of object for list of loads info
! In  time           : current time
! In  typres         : type of coefficeitns (real or complex)
! IO  vect_elem      : name of vect_elem result
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbin = 3 
    integer, parameter :: nbout = 1
    character(len=8) :: lpain(nbin), lpaout(nbout)
    character(len=19) :: lchin(nbin), lchout(nbout)
!
    character(len=8) :: load_name, newnom
    character(len=16) :: option
    character(len=19) :: vect_elem, resu_elem
    character(len=24) :: ligrch, chgeom, chtime
    integer :: ibid, load_nume, nb_load, i_load
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
    aster_logical :: load_empty
    character(len=1) :: base
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    newnom    = '.0000000'
    chtime    = '&&VEDIME.CH_INST_R'
    resu_elem = '&&VEDIME.???????'
    base      = 'V'
!
! - Init fields
!
    call inical(nbin, lpain, lchin, nbout, lpaout,&
                lchout)
!
! - Result name for vect_elem
!
    vect_elem = vect_elemz
    if (vect_elem .eq. ' ') then
        vect_elem = '&&VEDIME'
    endif
!
! - Loads
!
    call load_list_info(load_empty, nb_load  , v_load_name, v_load_info,&
                        lload_name, lload_info)
!
! - Allocate result
!
    call detrsd('VECT_ELEM', vect_elem)
    call memare(base, vect_elem, model, ' ', ' ',&
                'CHAR_MECA')
    call reajre(vect_elem, ' ', base)
    if (load_empty) then
        goto 99
    endif
!
! - Geometry field
!
    call megeom(model, chgeom)
!
! - Time field
! 
    call mecact('V', chtime, 'MODELE', model, 'INST_R  ',&
                ncmp=1, nomcmp='INST', sr=time)
!
! - Input fields
!
    lpain(1)  = 'PGEOMER'
    lchin(1)  = chgeom(1:19)
    lpain(2)  = 'PTEMPSR'
    lchin(2)  = chtime(1:19)
!
! - Output field
!
    if (typres .eq. 'R') then
        lpaout(1) = 'PVECTUR'
    else
        lpaout(1) = 'PVECTUC'
    endif
!
! - Computation
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(i_load+1)  
        if ((load_nume.gt.0) .and. (load_nume.le.4)) then
            ligrch   = load_name//'.CHME.LIGRE'
!
! --------- Input field
!
            lchin(3) = load_name//'.CHME.CIMPO'
            if (load_nume .eq. 1) then
                if (typres .eq. 'R') then
                    option = 'MECA_DDLI_R'
                    lpain(3) = 'PDDLIMR'
                else
                    option = 'MECA_DDLI_C'
                    lpain(3) = 'PDDLIMC'
                endif
            else if (load_nume.eq.2) then
                option = 'MECA_DDLI_F'
                lpain(3) = 'PDDLIMF'
            else if (load_nume.eq.3) then
                option = 'MECA_DDLI_F'
                lpain(3) = 'PDDLIMF'
            else if (load_nume.eq.4) then
                ASSERT(typres.eq.'R')
                option = 'MECA_DDLI_R'
                lpain(3) = 'PDDLIMR'
            else
                ASSERT(.false.)
            endif
!
! --------- Generate new RESU_ELEM name
!
            call gcnco2(newnom)
            resu_elem(10:16) = newnom(2:8)
            call corich('E', resu_elem, i_load, ibid)
            lchout(1) = resu_elem
!
! --------- Computation
!
            call calcul('S'  , option, ligrch, nbin  , lchin,&
                        lpain, nbout , lchout, lpaout, base ,&
                        'OUI')
!
! --------- Copying output field
!
            call reajre(vect_elem, lchout(1), 'V')
!
        endif
    end do
!
 99 continue
    vect_elemz = vect_elem//'.RELR'
!
    call jedema()
end subroutine
