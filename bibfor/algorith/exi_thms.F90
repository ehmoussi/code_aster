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

function exi_thms(model, l_affe_all, list_elem_affe, nb_elem_affe)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/teattr.h"
!
!
!
    character(len=8), intent(in) :: model
    character(len=24), intent(in) :: list_elem_affe
    aster_logical, intent(in) :: l_affe_all
    integer, intent(in) :: nb_elem_affe
    aster_logical :: exi_thms
!
! --------------------------------------------------------------------------------------------------
!
!     RENVOIE .TRUE. SI PARMI LES ELEMENTS FINIS ASSOCIES AUX MAILLES
!     DONNEES, IL EN EXISTE UN QUI SOIT EN THMS
!     SI AUCUNE MAILLE N'EST DONNEE EN ENTREE (nb_elem_affe=0), ALORS
!     ON REGARDE TOUTES LES MAILLES DU MAILLAGE
!
! IN  MODELE : NOM DU MODELE
! IN  list_elem_affe : LISTE DES MAILLES SUR LESQUELLES ON FAIT LE TEST
! IN  nb_elem_affe   : NOMBRE DE MAILLES DANS list_elem_affe
!              SI nb_elem_affe = 0  ON FAIT LE TEST SUR TOUTES LES MAILLES DU
!              MAILLAGE ASSOCIÉE AU MODELE
! OUT EXI_THMS : .TRUE. SI C_PLAN TROUVE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_elem, nb_elem_mesh, iret, ielem, nume_elem, nutyel
    integer :: j_elem_affe
    character(len=8) :: mesh, rep
    character(len=16) :: notype
    integer, pointer :: maille(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    exi_thms = .false.
!
! - Access to model and mesh
!
    call jeveuo(model//'.MAILLE', 'L', vi=maille)
    call dismoi('NOM_MAILLA', model(1:8), 'MODELE', repk=mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_elem_mesh)
!
! - Mesh affectation
!
    if (l_affe_all) then
        nb_elem = nb_elem_mesh
    else
        call jeveuo(list_elem_affe, 'L', j_elem_affe)
        nb_elem = nb_elem_affe
    endif
!
! - Loop on elements
!
    do ielem = 1, nb_elem
!
! ----- Current element
!
        if (l_affe_all) then
            nume_elem = ielem
        else
            nume_elem = zi(j_elem_affe-1+ielem)
        endif
!
! ----- Access to element type
!
        nutyel = maille(nume_elem)
!
        if (nutyel .ne. 0) then
            call jenuno(jexnum('&CATA.TE.NOMTE', nutyel), notype)
!           exclusion des mailles de bord
            call teattr('S', 'BORD', rep, iret, typel=notype)
            if (rep(1:3).eq.'0  ')then
                call teattr('C', 'INTTHM', rep, iret, typel=notype)
                if (iret .eq. 0) then
                    if (rep(1:3) .eq. 'RED') then
                        exi_thms = .true.
                        goto 999
                    endif
                endif
            endif
        endif
    end do
!
999 continue
    call jedema()
end function
