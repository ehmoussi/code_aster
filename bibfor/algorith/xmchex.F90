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

subroutine xmchex(mesh, chpmod, chelex)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/celces.h"
#include "asterfort/cescre.h"
#include "asterfort/cesexi.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=19) :: chelex, chpmod
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (METHODE XFEM - CREATION CHAM_ELEM)
!
! CREATION D'UN CHAM_ELEM_S VIERGE POUR ETENDRE LE CHAM_ELEM
! A PARTIR DE LA STRUCTURE D UN CHAMP EXISTANT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NBMA   : NOMBRE DE MAILLES
! IN  CHPMOD : CHAMP DONT LA STRUCTURE SERT DE MODELE
! OUT CHELEX : CHAM_ELEM_S PERMETTANT DE CREER UN CHAM_ELEM "ETENDU"
!
!
!
!
!
    integer, parameter :: nbcmp  = 2
    character(len=8), parameter :: licmp(nbcmp) = (/ 'NPG_DYN ', 'NCMP_DYN'/)
    character(len=19) :: valk(2), chelsi
    integer :: vali(1)
    integer :: iad, ima, nbma
    integer :: jcesl,  jcesd
    integer, pointer :: cesd2(:) => null()
    integer, pointer :: cesv(:) => null()   
!
! ----------------------------------------------------------------------
!
    call jemarq()
    
    
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nbma)
!
! --- CREATION DU CHAM_ELEM_S VIERGE
!
    call cescre('V', chelex, 'ELEM', mesh, 'DCEL_I',&
                nbcmp, licmp, [-1], [-1], [-nbcmp])
!
! --- ACCES AU CHAM_ELEM_S
!
    call jeveuo(chelex(1:19)//'.CESD', 'L', jcesd)
    call jeveuo(chelex(1:19)//'.CESL', 'E', jcesl)
    call jeveuo(chelex(1:19)//'.CESV', 'E', vi=cesv)
!
! --- TRANSFORMATION CHAMP MODELE EN CHAMP SIMPLE
    chelsi = '&&XMCHEX.CHELSI'
    call celces(chpmod, 'V', chelsi)
    call jeveuo(chelsi(1:19)//'.CESD', 'L', vi=cesd2)
!
! --- AFFECTATION DES COMPOSANTES DU CHAM_ELEM_S
!
    do ima = 1, nbma
        call cesexi('C', jcesd, jcesl, ima, 1,&
                    1, 1, iad)
        if (iad .ge. 0) then
            vali(1) = 1
            valk(1) = chelex(1:19)
            valk(2) = 'ELEM'
            call utmess('F', 'CATAELEM_20', nk=2, valk=valk, si=vali(1))
        endif
        zl(jcesl-1-iad) = .true.
        cesv(1-1-iad) = cesd2(5+4*(ima-1)+2)
        call cesexi('C', jcesd, jcesl, ima, 1,&
                    1, 2, iad)
        if (iad .ge. 0) then
            vali(1) = 1
            valk(1) = chelex(1:19)
            valk(2) = 'ELEM'
            call utmess('F', 'CATAELEM_20', nk=2, valk=valk, si=vali(1))
        endif
        zl(jcesl-1-iad) = .true.
        cesv(1-1-iad) = cesd2(5+4*(ima-1)+3)
    end do
!
    call detrsd('CHAM_ELEM_S', chelsi)
!
    call jedema()
!
end subroutine
