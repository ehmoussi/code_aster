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
subroutine rescmp(cndiri, cnfext, cnfint, cnfnod,&
                  ds_contact,&
                  maxres, noddlm, numno)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cnocns.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
real(kind=8) :: maxres
character(len=8) :: noddlm
integer :: numno
character(len=19) :: cndiri, cnfext, cnfint, cnfnod
type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE - RESIDU)
!
! CALCULE LE MAX DES RESIDUS PAR CMP POUR LE RESIDU RESI_COMP_RELA 
!
! ----------------------------------------------------------------------
!
!
! IN  CNFEXT : VECT_ASSE DES FORCES EXTERIEURES APPLIQUEES (NEUMANN)
! IN  CNFINT : VECT_ASSE DES FORCES INTERIEURES
! IN  CNFNOD : VECT_ASSE DES FORCES NODALES
! IN  CNDIRI : VECT_ASSE REACTIONS D'APPUI
! OUT MAXRES : RESIDU RESI_NODA_RELA
! OUT NUMNO  : NUMERO DU NOEUD PENALISANT
! OUT NODDLM : NOM DU MECANISME SUR LEQUEL PORTE LE RESIDU
!
!
!
!
!
    integer :: nddmax
    parameter    (nddmax = 6)
    character(len=8) :: nomddl(nddmax)
    real(kind=8) :: maxddf(nddmax), maxddr(nddmax)
    integer :: numnod(nddmax)
!
    character(len=3) :: tsca
    integer :: cmpmax
    character(len=19) :: cnfnod_s, cnfint_s, cndiri_s, cnfext_s, cnctdf_s
    integer :: i, k
    real(kind=8) :: resim, fonam, res
    integer :: jcnsl
    integer :: licmpu(999)
    integer :: nb_cmp, nb_node, i_cmp, i_node, nbcmpu
    character(len=8) :: nomgd
    real(kind=8) :: epsi
    real(kind=8), pointer :: v_diri_cnsv(:) => null()
    real(kind=8), pointer :: v_fext_cnsv(:) => null()
    real(kind=8), pointer :: v_fint_cnsv(:) => null()
    real(kind=8), pointer :: v_fnod_cnsv(:) => null()
    real(kind=8), pointer :: v_cont_cnsv(:) => null()
    character(len=8), pointer :: v_fnod_cnsc(:) => null()
    character(len=8), pointer :: v_fnod_cnsk(:) => null()
    integer, pointer :: v_fnod_cnsd(:) => null()
    parameter    (epsi = 1.d-50)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - Convert to "simple" fields
!
    cnfnod_s = '&&RESCMP.CNFNOD_S'
    cnfint_s = '&&RESCMP.CNFINT_S'
    cndiri_s = '&&RESCMP.CNDIRI_S'
    cnfext_s = '&&RESCMP.CNFEXT_S'
    cnctdf_s = '&&RESCMP.CNCTDF_S'
    call cnocns(cnfnod, 'V', cnfnod_s)
    call jeveuo(cnfnod_s(1:19)//'.CNSV', 'L', vr=v_fnod_cnsv)
    call jeveuo(cnfnod_s(1:19)//'.CNSD', 'L', vi=v_fnod_cnsd)
    call jeveuo(cnfnod_s(1:19)//'.CNSL', 'L', jcnsl)
    call jeveuo(cnfnod_s(1:19)//'.CNSC', 'L', vk8=v_fnod_cnsc)
    call jeveuo(cnfnod_s(1:19)//'.CNSK', 'L', vk8=v_fnod_cnsk)
    call cnocns(cnfint, 'V', cnfint_s)
    call jeveuo(cnfint_s(1:19)//'.CNSV', 'L', vr=v_fint_cnsv)
    call cnocns(cndiri, 'V', cndiri_s)
    call jeveuo(cndiri_s(1:19)//'.CNSV', 'L', vr=v_diri_cnsv)
    call cnocns(cnfext, 'V', cnfext_s)
    call jeveuo(cnfext_s(1:19)//'.CNSV', 'L', vr=v_fext_cnsv)
    if (ds_contact%l_cnctdf) then
        call cnocns(ds_contact%cnctdf, 'V', cnctdf_s)
        call jeveuo(cnctdf_s(1:19)//'.CNSV', 'L', vr=v_cont_cnsv)
    endif
!
    nb_cmp = v_fnod_cnsd(2)
    nb_node = v_fnod_cnsd(1)

!
! --- NB DE CMP DANS LE CHAMP
!
    nbcmpu = 0
    do i_cmp = 1, nb_cmp
        do i_node = 1, nb_node
            if (zl(jcnsl-1+(i_node-1)*nb_cmp+i_cmp)) goto 20
        end do
        goto 30
 20     continue
        nbcmpu = nbcmpu + 1
        ASSERT(nbcmpu.lt.999)
        licmpu(nbcmpu) = i_cmp
 30     continue
    end do
!
! - Some checks
!
    nomgd = v_fnod_cnsk(2)
    ASSERT(nbcmpu .le. nddmax)
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
    ASSERT(tsca .eq. 'R')
!
    do i_cmp = 1, nbcmpu
        nomddl(i_cmp) = v_fnod_cnsc(licmpu(i_cmp))
        maxddf(i_cmp) = 0.d0
        maxddr(i_cmp) = 0.d0
        numnod(i_cmp) = 0
    end do
!
!
    do i_node = 1, nb_node
        do i_cmp = 1, nbcmpu
            k = licmpu(i_cmp)
            if (zl(jcnsl-1+(i_node-1)*nb_cmp+k)) then
                i = nb_cmp*(i_node-1)+k
                if (ds_contact%l_cnctdf) then
                    resim = abs(v_fint_cnsv(i)+v_diri_cnsv(i)+v_cont_cnsv(i)-v_fext_cnsv(i))
                else
                    resim = abs(v_fint_cnsv(i)+v_diri_cnsv(i)-v_fext_cnsv(i))
                endif
                fonam = abs(v_fnod_cnsv(i))
                if (resim .gt. maxddr(i_cmp)) then
                    maxddr(i_cmp)= resim
                    numnod(i_cmp)= i_node
                endif
                maxddf(i_cmp)=max(fonam,maxddf(i_cmp))
            endif
        end do
    end do
    maxres=0.d0
!
!
    do i_cmp = 1, nbcmpu
        if (maxddf(i_cmp) .gt. 0.d0) then
            res = maxddr(i_cmp)/maxddf(i_cmp)
        else
            res = -1
        endif
        if (res .gt. maxres) then
            maxres = res
            cmpmax = i_cmp
        endif
    end do
!
!  POUR INFO SI BESOIN NUMDDL  : NUMERO DU DDL PENALISANT
!    NUMDDL   = NUMN(CMPMAX)
!
    if (maxres .lt. epsi) then
        maxres = -1.d0
        numno = 0
        noddlm = '   '
    else
        numno = numnod(cmpmax)
        noddlm = nomddl(cmpmax)
    endif
!
    call detrsd('CHAM_NO_S', cnfnod_s)
    call detrsd('CHAM_NO_S', cnfint_s)
    call detrsd('CHAM_NO_S', cndiri_s)
    call detrsd('CHAM_NO_S', cnfext_s)
    call detrsd('CHAM_NO_S', cnctdf_s)
!
    call jedema()
!
end subroutine
