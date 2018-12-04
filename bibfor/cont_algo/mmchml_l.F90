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
!
subroutine mmchml_l(mesh, ds_contact, ligrcf, chmlcf)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/cfdisi.h"
#include "asterfort/mminfi.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: ligrcf
character(len=19), intent(in) :: chmlcf
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Create and fill input field
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
! In  ligrcf           : name of LIGREL for contact element
! In  chmlcf           : name of CHAM_LEM for input field
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: ncmp   = 60
    integer, parameter :: nceld1 = 4
    integer, parameter :: nceld2 = 4
    integer, parameter :: nceld3 = 4
    integer :: nt_liel, nb_grel, nb_liel, i_grel, i_liel, i_cont_pair, nb_cont_pair, i_zone
    integer :: vale_indx, decal, elem_slav_nume, patch_nume, jacobian_type, nb_cont_zone
    real(kind=8) :: r_axi, r_smooth
    character(len=19) :: sdappa
    character(len=24) :: chmlcf_celv
    integer :: jv_chmlcf_celv
    character(len=24) :: chmlcf_celd
    integer, pointer :: v_chmlcf_celd(:) => null()
    integer, pointer :: v_ligrcf_liel(:) => null()
    integer, pointer :: v_mesh_comapa(:) => null()
    character(len=24) :: sdappa_coef
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdcont_lagc
    real(kind=8), pointer :: v_sdcont_lagc(:) => null()
    character(len=24) :: sdappa_apli
    integer, pointer :: v_sdappa_apli(:) => null()
    integer, pointer :: typ_jaco(:) => null()
    character(len=24) :: sdcont_cyclac_hist
    real(kind=8), pointer :: v_sdcont_cyclac_hist(:) => null()
    character(len=24) :: sdcont_cyclac_etat
    integer, pointer :: v_sdcont_cyclac_etat(:) => null()
    character(len=24) :: sdappa_poid
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    character(len=24) :: sdappa_gapi
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    character(len=24) :: sdappa_nmcp
    integer, pointer :: v_sdappa_nmcp(:) => null()
    character(len=24) :: sdappa_apts
    real(kind=8), pointer :: v_sdappa_apts(:) => null()
    character(len=24) :: sdappa_aptm
    real(kind=8), pointer :: v_sdappa_aptm(:) => null()
    character(len=24) :: sdappa_apnp
    integer, pointer :: v_sdappa_apnp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Get parameters
!
    r_smooth     = real(cfdisi(ds_contact%sdcont_defi,'LISSAGE'),kind=8)
    r_axi        = real(cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE'),kind=8)
    nb_cont_pair = ds_contact%nb_cont_pair
    if (nb_cont_pair.eq.0) then
        go to 80
    end if
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi, 'NZOCO')
    AS_ALLOCATE(vi=typ_jaco, size= nb_cont_zone)
    do i_zone=1, nb_cont_zone
        typ_jaco(i_zone)= mminfi(ds_contact%sdcont_defi, 'TYPE_JACOBIEN', i_zone)
    end do
!
! - Access to input field
!
    chmlcf_celd = chmlcf//'.CELD'
    chmlcf_celv = chmlcf//'.CELV'
    call jeveuo(chmlcf_celd, 'L', vi = v_chmlcf_celd)
    call jeveuo(chmlcf_celv, 'E', jv_chmlcf_celv)
    nb_grel = v_chmlcf_celd(2)
!
! - Get pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! - Access to mesh
!
    call jeveuo(mesh//'.COMAPA','L',vi = v_mesh_comapa)
!
! - Access to contact objects
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    sdcont_lagc = ds_contact%sdcont_solv(1:14)//'.LAGC'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_poid = sdappa(1:19)//'.POID'
    sdappa_nmcp = sdappa(1:19)//'.NMCP'
    call jeveuo(sdcont_stat, 'L', vi = v_sdcont_stat)
    call jeveuo(sdcont_lagc, 'L', vr = v_sdcont_lagc)
    call jeveuo(sdappa_gapi, 'L', vr = v_sdappa_gapi)
    call jeveuo(sdappa_nmcp, 'L', vi = v_sdappa_nmcp)
    call jeveuo(sdappa_poid, 'L', vr = v_sdappa_poid)
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdappa_apli = sdappa(1:19)//'.APLI'
    sdappa_apts = sdappa(1:19)//'.APTS'
    sdappa_aptm = sdappa(1:19)//'.APTM'
    sdappa_apnp = sdappa(1:19)//'.APNP'
    call jeveuo(sdappa_coef, 'L', vr = v_sdappa_coef)
    call jeveuo(sdappa_apli, 'L', vi = v_sdappa_apli)
    call jeveuo(sdappa_apnp, 'L', vi = v_sdappa_apnp)
    call jeveuo(sdappa_apts, 'L', vr = v_sdappa_apts)
    call jeveuo(sdappa_aptm, 'L', vr = v_sdappa_aptm)
    sdcont_cyclac_etat = ds_contact%sdcont_solv(1:14)//'.CYCE'
    call jeveuo(sdcont_cyclac_etat, 'L', vi = v_sdcont_cyclac_etat)
    sdcont_cyclac_hist = ds_contact%sdcont_solv(1:14)//'.CYCH'
    call jeveuo(sdcont_cyclac_hist, 'L', vr = v_sdcont_cyclac_hist)
!
! - Fill input field
!
    nt_liel = 0
    do i_grel = 1, nb_grel
        decal   = v_chmlcf_celd(nceld1+i_grel)
        nb_liel = v_chmlcf_celd(decal+1)
        ASSERT(v_chmlcf_celd(decal+3).eq.ncmp)
        call jeveuo(jexnum(ligrcf//'.LIEL', i_grel), 'L', vi = v_ligrcf_liel)
        do i_liel = 1, nb_liel
! --------- Get patch
            i_cont_pair    = -v_ligrcf_liel(i_liel)
            elem_slav_nume = v_sdappa_apli(3*(i_cont_pair-1)+1)
            i_zone         = v_sdappa_apli(3*(i_cont_pair-1)+3)
            patch_nume     = v_mesh_comapa(elem_slav_nume)
            ! Pour le cyclage : Numero de maille maitre correspondant
            v_sdcont_cyclac_hist(22*(patch_nume-1)+11) = v_sdappa_apli(3*(i_cont_pair-1)+2)
            !On fait le cyclage ou pas
            if (v_sdcont_cyclac_hist(22*(patch_nume-1)+11) .ne. &
                v_sdcont_cyclac_hist(22*(patch_nume-1)+22) ) then
                v_sdcont_cyclac_hist(22*(patch_nume-1)+10) = 1
            endif
            jacobian_type  = typ_jaco(i_zone)
! --------- Adress in CHAM_ELEM
            vale_indx = jv_chmlcf_celv-1+v_chmlcf_celd(decal+nceld2+nceld3*(i_liel-1)+4)
! --------- Set values in CHAM_ELEM
            zr(vale_indx-1+1)  = r_smooth
            zr(vale_indx-1+2)  = jacobian_type
            zr(vale_indx-1+3)  = v_sdappa_nmcp(patch_nume)
            zr(vale_indx-1+4)  = v_sdappa_gapi(patch_nume)*v_sdappa_poid(patch_nume)
            zr(vale_indx-1+5)  = v_sdcont_stat(patch_nume)
            zr(vale_indx-1+6)  = v_sdcont_lagc(patch_nume)
            zr(vale_indx-1+7)  = v_sdcont_cyclac_etat(patch_nume)
            zr(vale_indx-1+8)  = v_sdappa_apnp(i_cont_pair)
            zr(vale_indx-1+9)  = v_sdappa_apts(16*(i_cont_pair-1)+1)
            zr(vale_indx-1+10) = v_sdappa_apts(16*(i_cont_pair-1)+2)
            zr(vale_indx-1+11) = v_sdappa_apts(16*(i_cont_pair-1)+3)
            zr(vale_indx-1+12) = v_sdappa_apts(16*(i_cont_pair-1)+4)
            zr(vale_indx-1+13) = v_sdappa_apts(16*(i_cont_pair-1)+5)
            zr(vale_indx-1+14) = v_sdappa_apts(16*(i_cont_pair-1)+6)
            zr(vale_indx-1+15) = v_sdappa_apts(16*(i_cont_pair-1)+7)
            zr(vale_indx-1+16) = v_sdappa_apts(16*(i_cont_pair-1)+8)
            zr(vale_indx-1+17) = v_sdappa_apts(16*(i_cont_pair-1)+9)
            zr(vale_indx-1+18) = v_sdappa_apts(16*(i_cont_pair-1)+10)
            zr(vale_indx-1+19) = v_sdappa_apts(16*(i_cont_pair-1)+11)
            zr(vale_indx-1+20) = v_sdappa_apts(16*(i_cont_pair-1)+12)
            zr(vale_indx-1+21) = v_sdappa_apts(16*(i_cont_pair-1)+13)
            zr(vale_indx-1+22) = v_sdappa_apts(16*(i_cont_pair-1)+14)
            zr(vale_indx-1+23) = v_sdappa_apts(16*(i_cont_pair-1)+15)
            zr(vale_indx-1+24) = v_sdappa_apts(16*(i_cont_pair-1)+16)
            zr(vale_indx-1+25) = v_sdappa_aptm(16*(i_cont_pair-1)+1)
            zr(vale_indx-1+26) = v_sdappa_aptm(16*(i_cont_pair-1)+2)
            zr(vale_indx-1+27) = v_sdappa_aptm(16*(i_cont_pair-1)+3)
            zr(vale_indx-1+28) = v_sdappa_aptm(16*(i_cont_pair-1)+4)
            zr(vale_indx-1+29) = v_sdappa_aptm(16*(i_cont_pair-1)+5)
            zr(vale_indx-1+30) = v_sdappa_aptm(16*(i_cont_pair-1)+6)
            zr(vale_indx-1+31) = v_sdappa_aptm(16*(i_cont_pair-1)+7)
            zr(vale_indx-1+32) = v_sdappa_aptm(16*(i_cont_pair-1)+8)
            zr(vale_indx-1+33) = v_sdappa_aptm(16*(i_cont_pair-1)+9)
            zr(vale_indx-1+34) = v_sdappa_aptm(16*(i_cont_pair-1)+10)
            zr(vale_indx-1+35) = v_sdappa_aptm(16*(i_cont_pair-1)+11)
            zr(vale_indx-1+36) = v_sdappa_aptm(16*(i_cont_pair-1)+12)
            zr(vale_indx-1+37) = v_sdappa_aptm(16*(i_cont_pair-1)+13)
            zr(vale_indx-1+38) = v_sdappa_aptm(16*(i_cont_pair-1)+14)
            zr(vale_indx-1+39) = v_sdappa_aptm(16*(i_cont_pair-1)+15)
            zr(vale_indx-1+40) = v_sdappa_aptm(16*(i_cont_pair-1)+16)
            zr(vale_indx-1+41) = 0.d0
            zr(vale_indx-1+42) = 0.d0
            zr(vale_indx-1+43) = 0.d0
            zr(vale_indx-1+44) = 0.d0
            zr(vale_indx-1+45) = 0.d0
            zr(vale_indx-1+46) = 0.d0
            zr(vale_indx-1+47) = 0.d0
            zr(vale_indx-1+48) = 0.d0
            zr(vale_indx-1+49) = 0.d0
            zr(vale_indx-1+50) = 1.d0
        end do
        nt_liel = nt_liel + nb_liel
    enddo
    ASSERT(nt_liel .eq. nb_cont_pair)
    AS_DEALLOCATE(vi=typ_jaco)
!
80  continue
    call jedema()
!
end subroutine
