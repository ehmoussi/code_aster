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

subroutine cfrsmu(ds_contact, reapre)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cfdisd.h"
#include "asterfort/cfdisl.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    aster_logical :: reapre
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES)
!
! RESTAURATION DU LAGRANGE DE CONTACT APRES UN APPARIEMENT
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! IN  REAPRE : S'AGIT-IL DU PREMIER APPARIEMENT DU PAS DE TEMPS ?
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iliai, posnoe
    integer :: nbliai
    character(len=19) :: svmu, mu
    integer :: jsvmu, jmu
    character(len=24) :: numlia
    integer :: jnumli
    aster_logical :: lgcp
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! --- LE LAGRANGE DE CONTACT N'EST RESTAURE QU'EN GCP
!
    lgcp = cfdisl(ds_contact%sdcont_defi,'CONT_GCP')
!
    if (.not.lgcp) then
        goto 999
    endif
!
! --- ACCES OBJETS
!
    if (reapre) then
        svmu = ds_contact%sdcont_solv(1:14)//'.SVM0'
    else
        svmu = ds_contact%sdcont_solv(1:14)//'.SVMU'
    endif
    call jeveuo(svmu, 'L', jsvmu)
    mu = ds_contact%sdcont_solv(1:14)//'.MU'
    call jeveuo(mu, 'E', jmu)
    numlia = ds_contact%sdcont_solv(1:14)//'.NUMLIA'
    call jeveuo(numlia, 'L', jnumli)
!
! --- INFORMATIONS
!
    nbliai = cfdisd(ds_contact%sdcont_solv,'NBLIAI')
!
! --- SAUVEGARDE DU STATUT DE FROTTEMENT
!
    do iliai = 1, nbliai
        posnoe = zi(jnumli-1+4*(iliai-1)+2)
        zr(jmu-1+iliai) = zr(jsvmu-1+posnoe)
    end do
!
999 continue
!
    call jedema()
end subroutine
