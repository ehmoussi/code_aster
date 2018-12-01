! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine caliun(sdcont_, mesh_, model_)
!
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/caraun.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/creaun.h"
#include "asterfort/elimun.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/listun.h"
#include "asterfort/surfun.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
!
character(len=*), intent(in) :: sdcont_, mesh_, model_
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get informations for LIAISON_UNILATER in command
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  model            : name of model
! In  mesh             : name of mesh
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: sdcont, mesh, model
    character(len=16) :: keywf
    integer :: iform
    integer :: nb_unil_zone, nnocu, ntcmp
    character(len=24) :: nolino, nopono
    character(len=24) :: lisnoe, poinoe
    character(len=24) :: nbgdcu, coefcu, compcu, multcu, penacu
    character(len=24) :: sdunil_defi, sdcont_defi
    character(len=24) :: ndimcu
    integer :: jdim
    character(len=24) :: sdcont_paraci
    integer, pointer :: v_sdcont_paraci(:) => null()
    character(len=24) :: sdcont_paracr
    real(kind=8), pointer :: v_sdcont_paracr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    model       = model_(1:8)
    sdcont      = sdcont_
    mesh        = mesh_
    iform       = 4
    keywf       = 'ZONE'
    sdcont_defi = sdcont(1:8)//'.CONTACT'
    sdunil_defi = sdcont(1:8)//'.UNILATE'
!
! - Datastructure for contact definition
!
    sdcont_paraci = sdcont(1:8)//'.PARACI'
    call jeveuo(sdcont_paraci, 'E', vi=v_sdcont_paraci)
    sdcont_paracr = sdcont(1:8)//'.PARACR'
    call jeveuo(sdcont_paracr, 'E', vr=v_sdcont_paracr)
!
! - Number of zones
!
    call getfac(keywf, nb_unil_zone)
    if (nb_unil_zone .ne. 0) then
! ----- Create datastructure for general parameters
        v_sdcont_paraci(4) = iform
        ndimcu = sdunil_defi(1:16)//'.NDIMCU'
        call wkvect(ndimcu, 'G V I', 2, jdim)
! ----- Set datastructure for general parameters
        nbgdcu = '&&CALIUN.NBGDCU'
        compcu = '&&CARAUN.COMPCU'
        multcu = '&&CARAUN.MULTCU'
        coefcu = '&&CARAUN.COEFCU'
        penacu = '&&CARAUN.PENACU'
        call caraun(sdcont, nb_unil_zone, nbgdcu, coefcu,&
                    compcu, multcu, penacu, ntcmp)
! ----- Get list of nodes
        nopono = '&&CALIUN.PONOEU'
        nolino = '&&CALIUN.LINOEU'
        call listun(mesh, keywf, nb_unil_zone, nopono, nnocu,&
                    nolino)
! ----- Clean list of nodes
        lisnoe = '&&CALIUN.LISNOE'
        poinoe = '&&CALIUN.POINOE'
        call elimun(mesh, model, keywf, nb_unil_zone, nbgdcu,&
                    compcu, nopono, nolino, lisnoe, poinoe,&
                    nnocu)
! ----- Get list of components
        call creaun(sdcont, mesh, model, nb_unil_zone, nnocu,&
                    lisnoe, poinoe, nbgdcu, coefcu, compcu,&
                    multcu, penacu)
! ----- Debug
        call surfun(sdcont, mesh)
! ----- Clean
        call jedetr(nolino)
        call jedetr(nopono)
        call jedetr(lisnoe)
        call jedetr(poinoe)
        call jedetr(nbgdcu)
        call jedetr(coefcu)
        call jedetr(compcu)
        call jedetr(multcu)
        call jedetr(penacu)
!
    endif
!
    call jedema()
!
end subroutine
