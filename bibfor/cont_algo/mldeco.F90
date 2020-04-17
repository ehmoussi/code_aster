! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine mldeco(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONSTINUE LAC - POST-TRAITEMENT)
!
! GESTION DE LA DECOUPE
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
    character(len=19) :: sdcont_stat, sdcont_zeta,  sdcont_zgpi
    character(len=19) :: sdcont_zpoi, sdcont_znmc,  sdcont_zcoe
    character(len=19) :: sdappa
    character(len=24) :: sdappa_gapi, sdappa_poid, sdappa_nmcp, sdappa_coef
    integer, pointer :: v_sdcont_stat(:) => null()
    integer, pointer :: v_sdcont_zeta(:) => null()
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    real(kind=8), pointer :: v_sdcont_zgpi(:) => null()
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    real(kind=8), pointer :: v_sdcont_zpoi(:) => null()
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    real(kind=8), pointer :: v_sdcont_zcoe(:) => null()
    integer, pointer :: v_sdappa_nmcp(:) => null()
    integer, pointer :: v_sdcont_znmc(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    sdcont_zeta = ds_contact%sdcont_solv(1:14)//'.ZETA'
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_poid = sdappa(1:19)//'.POID'
    sdappa_nmcp = sdappa(1:19)//'.NMCP'
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdcont_zgpi = ds_contact%sdcont_solv(1:14)//'.ZGPI'
    sdcont_zpoi = ds_contact%sdcont_solv(1:14)//'.ZPOI'
    sdcont_znmc = ds_contact%sdcont_solv(1:14)//'.ZNMC'
    sdcont_zcoe = ds_contact%sdcont_solv(1:14)//'.ZCOE'
    call jeveuo(sdcont_stat, 'L', vi = v_sdcont_stat)
    call jeveuo(sdappa_gapi, 'L', vr = v_sdappa_gapi)
    call jeveuo(sdappa_nmcp, 'L', vi = v_sdappa_nmcp)
    call jeveuo(sdappa_poid, 'L', vr = v_sdappa_poid)
    call jeveuo(sdappa_coef, 'L', vr = v_sdappa_coef)
    call jeveuo(sdcont_zeta, 'E', vi = v_sdcont_zeta)
    call jeveuo(sdcont_zpoi, 'E', vr = v_sdcont_zpoi)
    call jeveuo(sdcont_znmc, 'E', vi = v_sdcont_znmc)
    call jeveuo(sdcont_zcoe, 'E', vr = v_sdcont_zcoe)
    call jeveuo(sdcont_zgpi, 'E', vr = v_sdcont_zgpi)
!
! --- SAUVEGARDE DE L ETAT DE CONTACT EN CAS DE REDECOUPAGE
!
    v_sdcont_zeta(:)=v_sdcont_stat(:)
    v_sdcont_zgpi(:)=v_sdappa_gapi(:)
    v_sdcont_zpoi(:)=v_sdappa_poid(:)
    v_sdcont_znmc(:)=v_sdappa_nmcp(:)
    v_sdcont_zcoe(:)=v_sdappa_coef(:)

    call jedema()
!
end subroutine
