! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine celces(celz, basez, cesz, l_copy_nan_)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/cheksd.h"
#include "asterfort/assert.h"
#include "asterfort/cescre.h"
#include "asterfort/cesexi.h"
#include "asterfort/cmpcha.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisdg.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/nbelem.h"
#include "asterfort/sdmpic.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=*), intent(in) :: celz, cesz, basez
aster_logical, optional, intent(in) :: l_copy_nan_
!
! --------------------------------------------------------------------------------------------------
!
! Fields
!
! Convert an elementary field (CHAM_ELEM) in a simple elementary field (CHAM_ELEM_S)
!
! WARNING: doesn't work on "tardif" cells
!
! --------------------------------------------------------------------------------------------------
!
! In  cel              : name of CHAM_ELEM to convert
! In  ces              : name of CHAM_ELEM_S
! In  base             : JEVEUX base to create CHAM_ELEM_S
! In  l_copy_nan       : flag to copy NaN values
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1) :: base
    character(len=3) :: tsca
    character(len=4) :: typces, kmpic
    character(len=8) :: mesh, nomgd
    character(len=19) :: cel, ces, ligrel
    integer :: nec, gd, nb_cmp_mx, nb_cell
    integer :: iadg, nume_cmp, nb_cmp
    integer :: jv_celv, jv_molo
    integer :: jv_cesl, jv_cesv, jv_cesd
    integer :: ieq, i_cmp_cata, i_grel, i_elem, ierr
    integer :: nb_pt, nb_grel, imolo, nb_grel_ligr
    integer :: i_cmp, i_pt, i_spt, elem_nume, iad, vali(2)
    integer :: nb_pt_max, nb_elem, nb_cmp_max, nb_spt, nb_dyn, nb_dyn_max, lgcata
    integer :: ico, adiel, nb_cmp_cumu
    character(len=24) :: valk(2)
    aster_logical :: sdveri, l_copy_nan
    integer, pointer :: v_liel(:) => null()
    integer, pointer :: v_liel_long(:) => null()
    integer, pointer :: v_celd(:) => null()
    integer, pointer :: v_long_pt(:) => null()
    integer, pointer :: long_pt_cumu(:) => null()
    integer, pointer :: v_nbcmp(:) => null()
    integer, pointer :: v_nbpt(:) => null()
    integer, pointer :: v_nbspt(:) => null()
    integer, pointer :: cata_to_field(:) => null()
    integer, pointer :: field_to_cata(:) => null()
    character(len=8), pointer :: cmp_name(:) => null()
!
#define numail(i_grel,i_elem) v_liel(v_liel_long(i_grel)+i_elem-1)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    cel  = celz
    ces  = cesz
    base = basez
!
! - Parameter: debug ?
!
    sdveri = ASTER_FALSE
!
! - Parameter: copy the NaN ?
!
    l_copy_nan = ASTER_TRUE
    if ( present(l_copy_nan_)) then
        l_copy_nan = l_copy_nan_
    endif
!
! - Some checks
!
    if (sdveri) then
        call cheksd(cel, 'sd_cham_elem', ierr)
        ASSERT(ierr .eq. 0)
    endif
    call exisd('CHAM_ELEM', cel, ierr)
    ASSERT(ierr .eq. 1)
!
! - Suppress old CHAM_ELEM_S
!
    call detrsd('CHAM_ELEM_S', ces)
!
! - For MPI
!
    call dismoi('MPI_COMPLET', cel, 'CHAM_ELEM', repk=kmpic)
    ASSERT((kmpic.eq.'OUI').or.(kmpic.eq.'NON'))
    if (kmpic .eq. 'NON') then
        call sdmpic('CHAM_ELEM', cel)
    endif
!
! - Some parameters about CHAM_ELEM
!
    call dismoi('NOM_MAILLA', cel, 'CHAM_ELEM', repk=mesh)
    call dismoi('NOM_GD'    , cel, 'CHAM_ELEM', repk=nomgd)
    call dismoi('NOM_LIGREL', cel, 'CHAM_ELEM', repk=ligrel)
    call dismoi('TYPE_CHAMP', cel, 'CHAM_ELEM', repk=typces)
!
! - Some parameters about mesh
!
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_cell)
!
! - Some parameters about physical quantity
!
    call dismoi('NB_EC'   , nomgd, 'GRANDEUR', repi=nec)
    call dismoi('NUM_GD'  , nomgd, 'GRANDEUR', repi=gd)
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
!
! - Access to CHAM_ELEM
!
    call jeveuo(cel//'.CELV', 'L', jv_celv)
    call jeveuo(cel//'.CELD', 'L', vi=v_celd)
    nb_grel = v_celd(2)
!
! - Access to LIGREL
!
    call jeveuo(ligrel//'.LIEL', 'L', vi=v_liel)
    call jeveuo(jexatr(ligrel//'.LIEL', 'LONCUM'), 'L', vi=v_liel_long)
    call jelira(ligrel//'.LIEL', 'NUTIOC', nb_grel_ligr)
    if (nb_grel_ligr .ne. nb_grel) then
        valk(1)=cel
        valk(2)=ligrel
        vali(1)=nb_grel
        vali(2)=nb_grel_ligr
        call utmess('F', 'CALCULEL_19', nk=2, valk=valk, ni=2, vali=vali)
    endif
!
! - Create objects for global components (catalog) <=> local components (field)
!
    call cmpcha(cel      , cmp_name, cata_to_field, field_to_cata, nb_cmp,&
                nb_cmp_mx)
!
! - Allocate objects for number of Gauss points, sub-points and components
!
    AS_ALLOCATE(vi=v_nbpt , size=nb_cell)
    AS_ALLOCATE(vi=v_nbspt, size=nb_cell)
    v_nbspt(1:nb_cell) = 1
    AS_ALLOCATE(vi=v_nbcmp, size=nb_cell)
!
! - Get number of Gauss points, sub-points and components
!
    nb_pt_max  = 0
    nb_dyn_max = 0
    do i_grel = 1, nb_grel
        nb_elem = nbelem(ligrel,i_grel)
        imolo   = v_celd(v_celd(4+i_grel)+2)
        if (imolo .ne. 0) then
! --------- Access to located components
            call jeveuo(jexnum('&CATA.TE.MODELOC', imolo), 'L', jv_molo)
            ASSERT(zi(jv_molo-1+1) .le. 3)
            ASSERT(zi(jv_molo-1+2) .eq. gd)
            nb_pt     = mod(zi(jv_molo-1+4),10000)
            nb_pt_max = max(nb_pt_max,nb_pt)
! --------- Update maximum number of components on all cells
            nb_cmp_max = 0
            do i_pt = 1, nb_pt
                iadg = jv_molo - 1 + 5
                do i_cmp = 1, nb_cmp_mx
                    if (exisdg(zi(iadg),i_cmp)) then
                        nb_cmp_max = max(nb_cmp_max,i_cmp)
                    endif
                end do
            end do
! --------- Loop on all cells in GREL
            do i_elem = 1, nb_elem
                elem_nume = numail(i_grel, i_elem)
                if (elem_nume .ne. 0) then
! ----------------- Get number of sub-points
                    nb_spt = v_celd(v_celd(4+i_grel)+4+4*(i_elem-1)+1)
! ----------------- Get number of (dynamic) components
                    if (nomgd(1:5) .eq. 'VARI_') then
                        nb_dyn     = v_celd(v_celd(4+i_grel)+4+4*(i_elem-1)+2)
                        nb_dyn     = max(nb_dyn,1)
                        nb_dyn_max = max(nb_dyn_max,nb_dyn)
                    endif
! ----------------- Save number of Gauss points and sub-points
                    v_nbpt(elem_nume)  = nb_pt
                    v_nbspt(elem_nume) = nb_spt
! ----------------- Save number of components
                    if (nomgd(1:5) .eq. 'VARI_') then
                        v_nbcmp(elem_nume) = nb_dyn
                    else
                        v_nbcmp(elem_nume) = cata_to_field(nb_cmp_max)
                    endif
                endif
            end do
        endif
    end do
    ASSERT(nb_pt_max .ne. 0)
    if (nomgd(1:5) .eq. 'VARI_') then
        nb_cmp = -nb_dyn_max
    endif
!
! - Allocate the CHAM_ELEM_S
!
    call cescre(base  , ces     , typces, mesh   , nomgd,&
                nb_cmp, cmp_name, v_nbpt, v_nbspt, v_nbcmp)
!
! - Access to the CHAM_ELEM_S
!
    call jeveuo(ces//'.CESD', 'E', jv_cesd)
    call jeveuo(ces//'.CESL', 'E', jv_cesl)
    call jeveuo(ces//'.CESV', 'E', jv_cesv)
!
! - Transfer
!
    if (nomgd(1:5) .ne. 'VARI_') then
        call wkvect('&&CELCES.LONG_PT', 'V V I', nb_pt_max, vi=v_long_pt)
        AS_ALLOCATE(vi=long_pt_cumu, size=nb_pt_max)
        do i_grel = 1, nb_grel
            imolo = v_celd(v_celd(4+i_grel)+2)
            if (imolo .ne. 0) then
! ------------- Access to located components
                call jeveuo(jexnum('&CATA.TE.MODELOC', imolo), 'L', jv_molo)
                nb_pt   = mod(zi(jv_molo-1+4),10000)
                nb_elem = nbelem(ligrel, i_grel)
! ------------- Number of components for each Gauss point
                do i_pt = 1, nb_pt
                    ico  = 0
                    do i_cmp = 1, nb_cmp
                        nume_cmp = field_to_cata(i_cmp)
                        if (exisdg(zi(jv_molo - 1 + 5), nume_cmp)) then
                            ico = ico + 1
                        endif
                    end do
                    v_long_pt(i_pt) = ico
                end do
! ------------- Cumulated number of components
                nb_cmp_cumu = 0
                do i_pt = 1, nb_pt
                    long_pt_cumu(i_pt) = nb_cmp_cumu
                    nb_cmp_cumu = nb_cmp_cumu + v_long_pt(i_pt)
                end do
! ------------- Loop on cells
                do i_elem = 1, nb_elem
                    elem_nume = numail(i_grel,i_elem)
                    if (elem_nume .ge. 0) then
                        nb_spt = v_celd(v_celd(4+i_grel)+4+4* (i_elem-1)+1)
                        adiel  = v_celd(v_celd(4+i_grel)+4+4* (i_elem-1)+4)
! --------------------- Loop on Gauss points
                        do i_pt = 1, nb_pt
                            ico = 0
                            do i_cmp = 1, nb_cmp
                                nume_cmp = field_to_cata(i_cmp)
                                if (exisdg(zi(jv_molo - 1 + 5), nume_cmp)) then
                                    ico   = ico + 1
                                    i_cmp_cata = cata_to_field(nume_cmp)
                                    ASSERT(i_cmp_cata .eq. i_cmp)
! --------------------------------- Loop on sub-points
                                    do i_spt = 1, nb_spt
                                        call cesexi('S', jv_cesd, jv_cesl, elem_nume, i_pt,&
                                                    i_spt, i_cmp_cata, iad)
                                        iad = abs(iad)
                                        zl(jv_cesl-1+iad) = ASTER_TRUE
                                        ieq = adiel - 1 + nb_spt*long_pt_cumu(i_pt) +&
                                              (i_spt-1)*v_long_pt(i_pt) + ico
                                        if (tsca .eq. 'R') then
                                            if ((isnan(zr(jv_celv-1+ieq))) .and. &
                                                (.not.l_copy_nan)) then
                                                zl(jv_cesl-1+iad) = ASTER_FALSE
                                            else
                                                zr(jv_cesv-1+iad) = zr(jv_celv-1+ieq)
                                            endif
                                        else if (tsca.eq.'I') then
                                            zi(jv_cesv-1+iad) = zi(jv_celv-1+ieq)
                                        else if (tsca.eq.'C') then
                                            zc(jv_cesv-1+iad) = zc(jv_celv-1+ieq)
                                        else if (tsca.eq.'L') then
                                            zl(jv_cesv-1+iad) = zl(jv_celv-1+ieq)
                                        else if (tsca.eq.'K8') then
                                            zk8(jv_cesv-1+iad) = zk8(jv_celv-1+ ieq)
                                        else if (tsca.eq.'K16') then
                                            zk16(jv_cesv-1+iad) = zk16(jv_celv-1+ieq)
                                        else if (tsca.eq.'K24') then
                                            zk24(jv_cesv-1+iad) = zk24(jv_celv-1+ieq)
                                        else
                                            ASSERT(ASTER_FALSE)
                                        endif
                                    end do
                                endif
                            end do
                        end do
                    endif
                end do
            endif
        end do
    else
!       -- CAS DE VARI_* :
!       -------------------
        do i_grel = 1, nb_grel
            imolo = v_celd(v_celd(4+i_grel)+2)
            if (imolo .ne. 0) then
                lgcata = v_celd(v_celd(4+i_grel)+3)
! ------------- Access to located components
                call jeveuo(jexnum('&CATA.TE.MODELOC', imolo), 'L', jv_molo)
                nb_pt   = mod(zi(jv_molo-1+4),10000)
                nb_elem = nbelem(ligrel, i_grel)
                ASSERT(nb_pt.eq.lgcata)
! ------------- Loop on cells
                do i_elem = 1, nb_elem
                    elem_nume = numail(i_grel, i_elem)
                    if (elem_nume .ge. 0) then
                        nb_spt = v_celd(v_celd(4+i_grel)+4+4* (i_elem-1)+1)
                        nb_dyn = max(v_celd(v_celd(4+i_grel)+4+4* (i_elem-1)+ 2),1)
                        adiel  = v_celd(v_celd(4+i_grel)+4+4* (i_elem-1)+4)
                        do i_pt = 1, nb_pt
                            do i_spt = 1, nb_spt
                                do i_cmp = 1, nb_dyn
                                    call cesexi('S', jv_cesd, jv_cesl, elem_nume, i_pt,&
                                                i_spt, i_cmp, iad)
                                    iad = abs(iad)
                                    zl(jv_cesl-1+iad) = ASTER_TRUE
                                    ieq = adiel - 1 + ((i_pt-1)*nb_spt+i_spt-1)* nb_dyn + i_cmp
                                    if (tsca .eq. 'R') then
                                        zr(jv_cesv-1+iad) = zr(jv_celv-1+ieq)
                                    else
                                        ASSERT(ASTER_FALSE)
                                    endif
                                end do
                            end do
                        end do
                    endif
                end do
            end if
        end do
    endif
!
    if (sdveri) then
        call cheksd(ces, 'sd_cham_elem_s', ierr)
        ASSERT(ierr .eq. 0)
    endif
!
    call jedetr('&&CELCES.TMP_NUCMP')
    AS_DEALLOCATE(vi=v_nbpt)
    AS_DEALLOCATE(vi=v_nbspt)
    AS_DEALLOCATE(vi=v_nbcmp)
    call jedetr('&&CELCES.LONG_PT')
    AS_DEALLOCATE(vi=long_pt_cumu)
    AS_DEALLOCATE(vi = cata_to_field)
    AS_DEALLOCATE(vi = field_to_cata)
    AS_DEALLOCATE(vk8 = cmp_name)
    call jedema()
end subroutine
