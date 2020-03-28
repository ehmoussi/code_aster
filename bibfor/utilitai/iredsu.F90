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
!
subroutine iredsu(macr, fileUnit, versio)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/resuPrintIdeas.h"
#include "asterfort/irmad0.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsexch.h"
#include "asterfort/rslipa.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
integer, intent(in) :: fileUnit, versio
character(len=*), intent(in) :: macr
!
!     BUT:
!       IMPRESSION D'UN CONCEPT MACR_ELEM_DYNA AU FORMAT "IDEAS"
!       ATTENTION: le dataset 481 est en minuscules.
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MACR      : NOM DU CONCEPT MACR_ELEM_DYNA
! IN   IFC       : UNITE LOGIQUE D'ECRITURE
! IN   VERSIO    : VERSION D'IMPRESSION
!
!      SORTIE :
!-------------
!
! ......................................................................
!
    integer :: i, icol, idrx, idry, idrz, idx, idy, idz
    integer :: ifor, im, imat
    integer :: in, ind, inoe, inoeu, iord, iret, is, is2, ityp, i2
    integer :: j, k, m2, nbordr, nstat
    integer :: jnoeu
    integer :: nbnoeu, nbmodt, nbmode, nbmods, ntriar, ntriam
    character(len=8) :: macrel, noma, noeu, cmp
    character(len=16) :: fieldType
    character(len=19) :: basemo, noch19
    character(len=24) :: manono
    character(len=80) :: title
    real(kind=8), pointer :: mass_gene(:) => null()
    real(kind=8), pointer :: mass_jonc(:) => null()
    character(len=24), pointer :: mode_stat(:) => null()
    character(len=8), pointer :: noeuds(:) => null()
    real(kind=8), pointer :: part_infe(:) => null()
    real(kind=8), pointer :: part_supe(:) => null()
    real(kind=8), pointer :: rigi_gene(:) => null()
    real(kind=8), pointer :: rigi_jonc(:) => null()
    real(kind=8), pointer :: mael_raid_vale(:) => null()
    real(kind=8), pointer :: mael_raid_vali(:) => null()
    character(len=24), pointer :: mael_refe(:) => null()
    integer, pointer :: ordr(:) => null()
    real(kind=8), pointer :: mael_mass_vale(:) => null()
    real(kind=8), pointer :: mael_mass_vali(:) => null()
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    macrel = macr
!
    call jeveuo(macrel//'.MAEL_REFE', 'L', vk24=mael_refe)
    basemo = mael_refe(1)(1:19)
    noma = mael_refe(2)(1:8)
    manono = noma//'.NOMNOE'
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnoeu)
    call rslipa(basemo, 'NOEUD_CMP', '&&IREDSU.LINOEU', jnoeu, nbmodt)
!
    do im = 1, nbmodt
        if (zk16(jnoeu+im-1) .ne. ' ') exit
    end do
    nbmode = im - 1
    nbmods = nbmodt - nbmode
!
!     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!                    --- IMPRESSION DES DDL DE JONCTION ---
!
!     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if (nbmods .ne. 0) then
        AS_ALLOCATE(vk8=noeuds, size=nbnoeu)
        inoeu = 1
        noeuds(1) = zk16(jnoeu+nbmode)(1:8)
        do im = 2, nbmods
            noeu = zk16(jnoeu+nbmode+im-1)(1:8)
            do j = 1, inoeu
                if (noeu .eq. noeuds(j)) exit
            end do
            inoeu = inoeu + 1
            noeuds(inoeu) = noeu
        end do
        if (versio .eq. 5) then
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   481'
            write (fileUnit,'(I10)') 1
            write (fileUnit,'(40A2)') 'Ju', 'nc'
            write (fileUnit,'(A)') '    -1'
            ind = 1
            icol = 7
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   757'
            write (fileUnit,'(2I10)') ind
            write (fileUnit,'(A)') 'DDL JONCTION'
            do in = 1, inoeu
                noeu = noeuds(in)
                call jenonu(jexnom(manono, noeu), inoe)
                idx = 0
                idy = 0
                idz = 0
                idrx = 0
                idry = 0
                idrz = 0
                do im = 1, nbmods
                    if (noeu .eq. zk16(jnoeu+nbmode+im-1)(1:8)) then
                        cmp = zk16(jnoeu+nbmode+im-1)(9:16)
                        if (cmp .eq. 'DX      ') then
                            idx = 1
                        else if (cmp .eq. 'DY      ') then
                            idy = 1
                        else if (cmp .eq. 'DZ      ') then
                            idz = 1
                        else if (cmp .eq. 'DRX     ') then
                            idrx = 1
                        else if (cmp .eq. 'DRY     ') then
                            idry = 1
                        else if (cmp .eq. 'DRZ     ') then
                            idrz = 1
                        endif
                    endif
                end do
                write (fileUnit,'(2I10,6I2)') inoe, icol, idx, idy, idz,&
                idrx, idry, idrz
            end do
            write (fileUnit,'(A)') '    -1'
        endif
    endif
!     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!                 --- IMPRESSION DES MODES DYNAMIQUES ---
!                 --- IMPRESSION DES MODES STATIQUES ---
!
!     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    fieldType = 'DEPL'
    call jeveuo(basemo//'.ORDR', 'L', vi=ordr)
    call jelira(basemo//'.ORDR', 'LONMAX', nbordr)
    AS_ALLOCATE(vk24=mode_stat, size=nbordr)
    nstat = 0
    do i = 1, nbordr
        iord = ordr(i)
        if (zk16(jnoeu+i-1) .ne. ' ') then
            call rsexch(' ', basemo, 'DEPL', iord, noch19,&
                        iret)
            if (iret .eq. 0) then
                nstat = nstat + 1
                mode_stat(nstat) = noch19
            endif
        else
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   481'
            write (fileUnit,'(I10)') 1
            write (fileUnit,'(40A2)') 'Ph', 'i_', 'a '
            write (fileUnit,'(A)') '    -1'
            title = 'MODE DYNAMIQUE'
            call resuPrintIdeas(fileUnit, basemo, ASTER_TRUE    ,&
                                1       , [iord],&
                                1       , 'DEPL',&
                                title_ = title)
        endif
    end do
    if (nstat .ne. 0) then
        write (fileUnit,'(A)') '    -1'
        write (fileUnit,'(A)') '   481'
        write (fileUnit,'(I10)') 1
        write (fileUnit,'(40A2)') 'Ps', 'i_', 'a '
        write (fileUnit,'(A)') '    -1'
        call irmad0(fileUnit, versio, nstat, mode_stat, fieldType)
    endif
    AS_DEALLOCATE(vk24=mode_stat)
!     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!                 --- IMPRESSION DES MATRICES MODALES ---
!
!     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    AS_ALLOCATE(vr=mass_gene, size=nbmode*nbmode)
    AS_ALLOCATE(vr=rigi_gene, size=nbmode*nbmode)
    if (nbmods .ne. 0) then
        AS_ALLOCATE(vr=mass_jonc, size=nbmods*nbmods)
        AS_ALLOCATE(vr=rigi_jonc, size=nbmods*nbmods)
        AS_ALLOCATE(vr=part_supe, size=nbmode*nbmods)
        AS_ALLOCATE(vr=part_infe, size=nbmode*nbmods)
    endif
!
    call jelira(macrel//'.MAEL_MASS_VALE','NMAXOC',ntriam)
    call jeveuo(jexnum(macrel//'.MAEL_MASS_VALE', 1), 'L', vr=mael_mass_vale)
    if (ntriam.gt.1) then
     call jeveuo(jexnum(macrel//'.MAEL_MASS_VALE', 2), 'L', vr=mael_mass_vali)
    else
     call jeveuo(jexnum(macrel//'.MAEL_MASS_VALE', 1), 'L', vr=mael_mass_vali)
    end if
    call jelira(macrel//'.MAEL_RAID_VALE','NMAXOC',ntriar)
    call jeveuo(jexnum(macrel//'.MAEL_RAID_VALE', 1), 'L', vr=mael_raid_vale) 
    if (ntriar.gt.1) then 
     call jeveuo(jexnum(macrel//'.MAEL_RAID_VALE', 2), 'L', vr=mael_raid_vali)
    else
     call jeveuo(jexnum(macrel//'.MAEL_RAID_VALE', 1), 'L', vr=mael_raid_vali)
    end if
    do im = 1, nbmode
        do i = 1, im
            k =im*(im-1)/2 + i
            mass_gene(1+i-1+(im-1)*nbmode) = mael_mass_vale(k)
            mass_gene(1+im-1+(i-1)*nbmode) = mael_mass_vale(k)
            rigi_gene(1+i-1+(im-1)*nbmode) = mael_raid_vale(k)
            rigi_gene(1+im-1+(i-1)*nbmode) = mael_raid_vale(k)
        end do
    end do
    do is = nbmode+1, nbmodt
        do im = 1, nbmode
            k = is*(is-1)/2 + im
            is2 = is - nbmode
            part_supe(1+is2-1+(im-1)*nbmods) = mael_mass_vale(k)
            part_infe(1+is2-1+(im-1)*nbmods) = mael_mass_vale(k)
        end do
        do i = nbmode+1, is
            k = is*(is-1)/2 + i
            i2 = i - nbmode
            is2 = is - nbmode
            mass_jonc(1+i2-1+(is2-1)*nbmods) = mael_mass_vale(k)
            mass_jonc(1+is2-1+(i2-1)*nbmods) = mael_mass_vale(k)
            rigi_jonc(1+i2-1+(is2-1)*nbmods) = mael_raid_vale(k)
            rigi_jonc(1+is2-1+(i2-1)*nbmods) = mael_raid_vale(k)
        end do
    end do
!
    m2 = nbmode * nbmode
    if (versio .eq. 5) then
        ityp = 4
        ifor = 1
        icol = 2
!
!        --- MASSE GENERALISEE ---
        write (fileUnit,'(A)') '    -1'
        write (fileUnit,'(A)') '   481'
        write (fileUnit,'(I10)') 1
        write (fileUnit,'(40A2)') 'Mg', 'en', '_a'
        write (fileUnit,'(A)') '    -1'
        imat = 131
        write (fileUnit,'(A)') '    -1'
        write (fileUnit,'(A)') '   252'
        write (fileUnit,'(I10)') imat
        write (fileUnit,'(5I10)') ityp, ifor, nbmode, nbmode, icol
        write (fileUnit,111) (mass_gene(1+i) , i= 0, m2-1 )
        write (fileUnit,'(A)') '    -1'
!
!        --- RAIDEUR GENERALISEE ---
        write (fileUnit,'(A)') '    -1'
        write (fileUnit,'(A)') '   481'
        write (fileUnit,'(I10)') 1
        write (fileUnit,'(40A2)') 'Kg', 'en', '_a'
        write (fileUnit,'(A)') '    -1'
        imat = 139
        write (fileUnit,'(A)') '    -1'
        write (fileUnit,'(A)') '   252'
        write (fileUnit,'(I10)') imat
        write (fileUnit,'(5I10)') ityp, ifor, nbmode, nbmode, icol
        write (fileUnit,111) (rigi_gene(1+i) , i= 0, m2-1 )
        write (fileUnit,'(A)') '    -1'
!
        if (nbmods .ne. 0) then
            m2 = nbmods * nbmods
!
!          --- MASSE CONDENSEE A LA JONCTION ---
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   481'
            write (fileUnit,'(I10)') 1
            write (fileUnit,'(40A2)') 'Mb', 'ar', '_a'
            write (fileUnit,'(A)') '    -1'
            imat = 134
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   252'
            write (fileUnit,'(I10)') imat
            write (fileUnit,'(5I10)') ityp, ifor, nbmods, nbmods, icol
            write (fileUnit,111) (mass_jonc(1+i) , i= 0, m2-1 )
            write (fileUnit,'(A)') '    -1'
!
!          --- RIGIDITE CONDENSEE A LA JONCTION ---
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   481'
            write (fileUnit,'(I10)') 1
            write (fileUnit,'(40A2)') 'Kb', 'ar', '_a'
            write (fileUnit,'(A)') '    -1'
            imat = 142
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   252'
            write (fileUnit,'(I10)') imat
            write (fileUnit,'(5I10)') ityp, ifor, nbmods, nbmods, icol
            write (fileUnit,111) (rigi_jonc(1+i) , i= 0, m2-1 )
            write (fileUnit,'(A)') '    -1'
!
            m2 = nbmode * nbmods
!
!          --- FACTEUR DE PARTICIPATION INFERIEUR ---
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   481'
            write (fileUnit,'(I10)') 1
            write (fileUnit,'(40A2)') 'Lm', 'at', '_a'
            write (fileUnit,'(A)') '    -1'
            imat = 132
            write (fileUnit,'(A)') '    -1'
            write (fileUnit,'(A)') '   252'
            write (fileUnit,'(I10)') imat
            write (fileUnit,'(5I10)') ityp, ifor, nbmode, nbmods, icol
            write (fileUnit,111) (part_infe(1+i) , i= 0, m2-1 )
            write (fileUnit,'(A)') '    -1'
!
        endif
    endif
!
111 format( 1p, 4d20.12 )
!
! --- MENAGE
!
    call jedetr('&&IREDSU.LINOEU')
    AS_DEALLOCATE(vk8=noeuds)
    AS_DEALLOCATE(vr=mass_gene)
    AS_DEALLOCATE(vr=rigi_gene)
    AS_DEALLOCATE(vr=mass_jonc)
    AS_DEALLOCATE(vr=rigi_jonc)
    AS_DEALLOCATE(vr=part_supe)
    AS_DEALLOCATE(vr=part_infe)
!
    call jedema()
end subroutine
