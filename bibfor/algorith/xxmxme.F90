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

subroutine xxmxme(mesh, model, list_func_acti, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/xmele1.h"
#include "asterfort/xmele3.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: list_func_acti(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES XFEM)
!
! CREATION SD DE RESOLUTION RESOCO
!
! ----------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  ds_contact       : datastructure for contact management
! In  list_func_acti   : list of active functionnalities
!
!

    integer :: ifm, niv
    integer :: nfiss
    integer, parameter :: nfismx =100
    character(len=24) :: tabfin
    integer :: jtabf
    integer :: ntpc
    integer :: ztabf, contac
    character(len=19) :: ligrel
    character(len=19) :: xindc0, xseuc0, xcohe0
    aster_logical :: lxffm, lxczm, lxfcm
    integer, pointer :: nfis(:) => null()
    integer, pointer :: xfem_cont(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! --- FONCTIONNALITES ACTIVEES
!
    ntpc = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    lxfcm = isfonc(list_func_acti,'CONT_XFEM')
    lxffm = isfonc(list_func_acti,'FROT_XFEM')
    lxczm = cfdisl(ds_contact%sdcont_defi,'EXIS_XFEM_CZM')
    ASSERT(lxfcm)
!
! --- INITIALISATIONS
!
    ligrel = model//'.MODELE'
!
! --- NOMBRE DE FISSURES
!
    call jeveuo(model//'.NFIS', 'L', vi=nfis)
    nfiss = nfis(1)
    if (nfiss .gt. nfismx) then
        call utmess('F', 'XFEM_2', si=nfismx)
    endif
    if (nfiss .le. 0) then
        call utmess('F', 'XFEM_3')
    endif
!
! --- TYPE DE CONTACT : CLASSIQUE OU MORTAR?
!
    call jeveuo(model//'.XFEM_CONT','L',vi=xfem_cont)
    contac = xfem_cont(1)
!
! --- NOM DES CHAMPS
!
    xindc0 = ds_contact%sdcont_solv(1:14)//'.XFI0'
    xseuc0 = ds_contact%sdcont_solv(1:14)//'.XFS0'
    xcohe0 = ds_contact%sdcont_solv(1:14)//'.XCO0'
    ztabf = cfmmvd('ZTABF')
!
! --- FONCTIONNALITES ACTIVEES
!
    ntpc = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    lxfcm = isfonc(list_func_acti,'CONT_XFEM')
    lxffm = isfonc(list_func_acti,'FROT_XFEM')
    lxczm = cfdisl(ds_contact%sdcont_defi,'EXIS_XFEM_CZM')
!
! --- TABLEAU CONTENANT LES INFORMATIONS DIVERSES
!
    tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    call wkvect(tabfin, 'V V R', ztabf*ntpc+1, jtabf)
    zr(jtabf) = ntpc
!
! --- PREPARATION CHAM_ELEM VIERGES
!
    if(contac.eq.1.or.contac.eq.3) then
        call xmele1(mesh, model, ds_contact, ligrel, nfiss,&
                    xindc0, 'PINDCOI', 'RIGI_CONT', list_func_acti)
    else if(contac.eq.2) then
        call xmele1(mesh, model, ds_contact, ligrel, nfiss,&
                    xindc0, 'PINDCOI', 'RIGI_CONT_M', list_func_acti)
    endif
!
    if (lxczm) then
!
!       SI CONTACT CLASSIQUE, CHAMP AUX PTS GAUSS
!
        if(contac.eq.1.or.contac.eq.3) then
            call xmele1(mesh, model, ds_contact, ligrel, nfiss,&
                        xcohe0, 'PCOHES', 'RIGI_CONT', list_func_acti)
!
!       SI CONTACT MORTAR, CHAMP ELNO
!
        else if(contac.eq.2) then
            call xmele3(mesh, model, ligrel, nfiss,&
                        xcohe0, 'PCOHES', 'RIGI_CONT_M', list_func_acti)
        else
            ASSERT(.false.)
        endif
    endif
    if (lxffm) then
        call xmele1(mesh, model, ds_contact, ligrel, nfiss,&
                    xseuc0, 'PSEUIL', 'RIGI_CONT', list_func_acti)
    endif
!
    call jedema()
!
end subroutine
