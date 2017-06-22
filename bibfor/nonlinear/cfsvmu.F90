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

subroutine cfsvmu(ds_contact, lconv)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisd.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jerazo.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    aster_logical, intent(in) :: lconv
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES)
!
! SAUVEGARDE DU LAGRANGE DE CONTACT POUR PERMETTRE LE TRANSPORT
! D'UN APPARIEMENT A UN AUTRE
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! IN  LCONV  : SAUVEGARDE T-ON UN ETAT CONVERGE ?
!
    integer :: nnoco
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
!
! --- LE LAGRANGE DE CONTACT N'EST SAUVEGARDE QU'EN GCP
!
    lgcp = cfdisl(ds_contact%sdcont_defi,'CONT_GCP')
!
    if (lgcp) then
!
! --- ACCES OBJETS
!
        if (lconv) then
            svmu = ds_contact%sdcont_solv(1:14)//'.SVM0'
        else
            svmu = ds_contact%sdcont_solv(1:14)//'.SVMU'
        endif
        call jeveuo(svmu, 'E', jsvmu)
        mu = ds_contact%sdcont_solv(1:14)//'.MU'
        call jeveuo(mu, 'L', jmu)
        numlia = ds_contact%sdcont_solv(1:14)//'.NUMLIA'
        call jeveuo(numlia, 'L', jnumli)
!
! --- INITIALISATIONS
!
        nnoco = cfdisi(ds_contact%sdcont_defi,'NNOCO')
        call jerazo(svmu, nnoco, 1)
!
! --- INFORMATIONS
!
        nbliai = cfdisd(ds_contact%sdcont_solv,'NBLIAI')
!
! --- SAUVEGARDE DU STATUT DE FROTTEMENT
!
        do iliai = 1, nbliai
            posnoe = zi(jnumli-1+4*(iliai-1)+2)
            ASSERT(posnoe.le.nnoco)
            ASSERT(zr(jsvmu-1+posnoe).eq.0.d0)
            zr(jsvmu-1+posnoe) = zr(jmu-1+iliai)
        end do
    endif
!
    call jedema()
end subroutine
