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

subroutine lrcomm(resu, typres, nbordr, chmat, carael,&
                  modele, noch, from_lire_resu)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvis.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmdoco.h"
#include "asterfort/nmdoch.h"
#include "asterfort/nmdorc.h"
#include "asterfort/ntdoch.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/rsorac.h"
#include "asterfort/utmess.h"
#include "asterfort/vrcomp.h"
#include "asterfort/wkvect.h"
#include "asterfort/comp_info.h"
#include "asterfort/getvid.h"
    integer :: nbordr
    character(len=8) :: resu, chmat, carael, modele
    character(len=16) :: typres
    character(len=*) :: noch
    aster_logical, intent(in), optional :: from_lire_resu
!
!     BUT:
!       STOCKER EVENTUELLEMENT : MODELE, CHAM_MATER, CARA_ELEM, EXCIT
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   RESU     : NOM DE LA SD_RESULTAT
! IN   TYPRES   : TYPE DE LA SD_RESULTAT
! IN   CHMAT    : NOM DU CHAM_MATER
! IN   CARAEL   : NOM DU CARA_ELEM
! IN   MODELE   : NOM DU MODELE
!
! ......................................................................
!
    integer :: iordr, lordr, nexci, jpara, ncmp, nocc
    integer :: i, iret, ibid, nbtrou, tord(1), nume_plan, nb_snap, niv, ifm
    real(kind=8) :: epsi, rbid
    character(len=8) :: crit, k8bid, resu_reuse
    character(len=19) :: list_load, list_load_save, vari, ligrmo, list_load_resu
    character(len=24) :: champ, noobj, compor, carcri, mod24, car24, champ_1
    complex(kind=8) :: cbid
    aster_logical :: l_etat_init, l_load_user, l_reuse, l_compor, l_cas
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infniv(ifm, niv)
!
    compor = ' '
    l_etat_init = .false.
    l_load_user = .true.
    l_reuse = .false.
    l_compor = .false.
    l_cas = .false.
!
    list_load      = '&&LRCOMM.LISCHA'
    list_load_resu = '&&LRCOMM.LISCHA'
    compor         = '&&LRCOMM.COMPOR'
    carcri         = '&&LRCOMM.CARCRI'
!
    ! detecter si COMPORTEMENT est renseigné
    call getfac('COMPORTEMENT', ncmp)
    if (ncmp .gt. 0) then 
        l_compor=.true.
    endif

    ! detecter reuse
    if (.not. (present(from_lire_resu))) then
        call getvid(' ', 'RESULTAT', scal = resu_reuse, nbret = nocc)
        if (nocc .ne. 0) then
            l_reuse = .true.
        endif
    endif

    ! cas particulier à traiter : reuse sans COMPORTEMENT
    l_cas = ((l_reuse) .and. (.not. l_compor))

    call rsorac(resu, 'LONUTI', ibid, rbid, k8bid,&
                cbid, epsi, crit, tord, 1,&
                nbtrou)
    nbordr=tord(1)            
    if (nbordr .le. 0) then
        call utmess('F', 'UTILITAI2_97')
    endif
    call wkvect('&&LRCOMM.NUME_ORDR', 'V V I', nbordr, lordr)
    call rsorac(resu, 'TOUT_ORDRE', ibid, rbid, k8bid,&
                cbid, epsi, crit, zi(lordr), nbordr,&
                nbtrou)
!
    if (chmat .ne. ' ') then
        do i = 1, nbordr
            iordr=zi(lordr+i-1)
            call rsadpa(resu, 'E', 1, 'CHAMPMAT', iordr, 0, sjv=jpara)
            zk8(jpara)=chmat
        end do
    endif
!
    if (carael .ne. ' ') then
        do i = 1, nbordr
            iordr=zi(lordr+i-1)
            call rsadpa(resu, 'E', 1, 'CARAELEM', iordr, 0, sjv=jpara)
            zk8(jpara)=carael
        end do
    endif
!
    if (typres .eq. 'MODE_EMPI') then
        call getvis(' ', 'NUME_PLAN', scal=nume_plan, nbret=iret)
        if (iret .eq. 0) then
            nume_plan = 0
        endif
        nb_snap = 0
        do i = 1, nbordr
            iordr=zi(lordr+i-1)
            call rsadpa(resu, 'E', 1, 'NUME_PLAN', iordr, 0, sjv=jpara)
            zi(jpara)=nume_plan
            call rsadpa(resu, 'E', 1, 'NB_SNAP', iordr, 0, sjv=jpara)
            zi(jpara)=nb_snap
            call rsadpa(resu, 'E', 1, 'NOM_CHAM', iordr, 0, sjv=jpara)
            zk24(jpara)=noch
        end do
    endif
!
    if (modele .ne. ' ') then
        if (typres(1:9) .eq. 'EVOL_NOLI') then
            call nmdorc(modele, chmat, l_etat_init, compor, carcri, l_implex_ = .false._1)
            if (niv .ge. 2) then
                call comp_info(modele(1:8), compor)
            endif
            if (compor .ne. ' ') then
                do i = 1, nbordr
                    iordr=zi(lordr+i-1)
                    call rsexch(' ', resu, 'COMPORTEMENT', iordr, champ,&
                                iret)
                    
                    if (l_cas) then
                        ! reuse sans COMPORTEMENT
                        if (iret .eq. 100)  then
                            if (iordr .eq. 1) then
                                ! 1er instant : pas de précédent instant : => ELAS
                                call copisd('CHAMP_GD', 'G', compor(1:19), champ(1:19))
                            else 
                                ! copier la carte COMPORTEMENT du précédent instant
                                call rsexch(' ', resu, 'COMPORTEMENT', iordr-1, champ_1, iret)
                                call copisd('CHAMP_GD', 'G', champ_1(1:19), champ(1:19))
                            endif
                            call rsnoch(resu, 'COMPORTEMENT', iordr)
                        endif 
                    else
                        ! autres cas (sans reuse, reuse avec compor), ou lire_resu
                        if (iret .le. 100) then
                            ! copier compor (ELAS ou celui donné par utilisateurs)
                            call copisd('CHAMP_GD', 'G', compor(1:19), champ( 1:19))
                            call rsnoch(resu, 'COMPORTEMENT', iordr)
                        endif  
                    endif  

                end do
            endif
        endif
        do i = 1, nbordr
            iordr=zi(lordr+i-1)
            call rsadpa(resu, 'E', 1, 'MODELE', iordr,&
                        0, sjv=jpara)
            zk8(jpara)=modele
        end do
    endif
!
    call getfac('EXCIT', nexci)
    if (nexci .gt. 0) then
        if (typres(1:4) .eq. 'DYNA' .or. typres(1:4) .eq. 'MODE') then
            call utmess('A', 'UTILITAI5_94', sk=typres)
            goto 60
        endif
        noobj ='12345678'//'.1234'//'.EXCIT.INFC'
        call gnomsd(' ', noobj, 10, 13)
        list_load_save = noobj(1:19)
        if (typres .eq. 'EVOL_ELAS' .or. typres .eq. 'EVOL_NOLI') then
            call nmdoch(list_load, l_load_user, list_load_resu)
        else if (typres.eq.'EVOL_THER') then
            call ntdoch(list_load)
        endif
        do i = 1, nbordr
            iordr=zi(lordr+i-1)
            call rsadpa(resu, 'E', 1, 'EXCIT', iordr,&
                        0, sjv=jpara)
            zk24(jpara)=list_load_save
        end do
        call copisd(' ', 'G', list_load, list_load_save)
    endif
 60 continue
!
! - Check comportment 
!
    if (typres(1:9) .eq. 'EVOL_NOLI') then
        do i = 1, nbordr
            iordr=zi(lordr+i-1)
            call rsexch(' ', resu, 'VARI_ELGA', iordr, vari,&
                        iret)
            
            if (iret .eq. 0) then
                if (modele .eq. ' ') call utmess('F','UTILITAI_97')
                call dismoi('NOM_LIGREL', modele, 'MODELE', repk=ligrmo)
                mod24 = modele
                car24 = carael
                if (l_cas) then
                    ! pour le cas reuse sans COMPORTEMENT 
                    ! vérifier entre VARI_ELGA existant et carte de comportement du resu
                    call rsexch(' ', resu, 'COMPORTEMENT', iordr, champ_1, iret)
                else
                    champ_1=compor
                endif
                call nmdoco(mod24, car24, champ_1)
                if (present(from_lire_resu)) then
                   call vrcomp(champ_1, vari, ligrmo, iret, type_stop = 'A',&
                               from_lire_resu = from_lire_resu)
                else
                   call vrcomp(champ_1, vari, ligrmo, iret, type_stop = 'A')
                endif 
                if (iret .eq. 1) then
                    call utmess('A', 'RESULT1_1')
                endif
            endif
        end do
    endif
!
    call jedetr('&&LRCOMM.NUME_ORDR')
!
    call jedema()
!
end subroutine
