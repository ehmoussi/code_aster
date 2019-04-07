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
! person_in_charge: nicolas.sellenet at edf.fr
! aslint: disable=W1504
!
subroutine lrfmed(resu, i, mfich, nomgd, typcha,&
                  option, param, nochmd, acces, nbordr,&
                  nnu, nis, nto, jnume, jlist,&
                  noma, nbcmpv, ncmpva, ncmpvm, prolz,&
                  iinst, crit, epsi, linoch, acce,&
                  npas0)
!
    use as_med_module, only: as_med_open
    implicit none
!
#include "asterf_types.h"
#include "MeshTypes_type.h"
#include "jeveux.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mfinvr.h"
#include "asterfort/codent.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/idensd.h"
#include "asterfort/indiis.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lrchme.h"
#include "asterfort/lrmtyp.h"
#include "asterfort/mdchin.h"
#include "asterfort/mdexpm.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/ulisog.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
integer, intent(out) :: npas0
!
! --------------------------------------------------------------------------------------------------
!
!       LECTURE DES RESULTATS PRESENTS DANS LES FICHIERS MED ET STOCKAGE DANS LA SD RESULTAT
!
! --------------------------------------------------------------------------------------------------
!
!      ENTREE :
!-------------
! IN   RESU     : NOM DE LA SD_RESULTAT
!
!      SORTIE :
!-------------
! OUT  PRCHNO   : PROFIL DU CHAMNO
!
! --------------------------------------------------------------------------------------------------
!
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6), parameter :: nompro ='LRFMED'
    integer :: vali(2)
    integer :: ndim, typgeo(MT_NTYMAX), letype
    integer :: nbtyp, nnotyp(MT_NTYMAX)
    integer :: renumd(MT_NTYMAX), nuanom(MT_NTYMAX, MT_NNOMAX)
    integer :: modnum(MT_NTYMAX), numnoa(MT_NTYMAX, MT_NNOMAX)
    integer :: nto, nnu, jlist, nbordr
    integer :: jnume, nis, npas, major, minor, rel
    med_idt :: fid, ifimed
    integer :: iret
    integer :: i, j
    integer :: ipas, iaux2
    integer :: mfich, jinst, itps
    integer :: ifm, niv, jnuom
    integer :: nbma, jnbpgm, jnbpmm, ordins, jnbsmm
    real(kind=8) :: epsi
    character(len=3) :: prolz
    character(len=4) :: acce
    character(len=8) :: resu, noma, typcha
    character(len=8) :: crit
    character(len=8) :: nomtyp(MT_NTYMAX), param
    character(len=10) :: acces
    character(len=16) :: linoch(100)
    character(len=19) :: nomch
    character(len=19) :: prefix, chanom, pchn1, resu19
    character(len=24) :: valk(2)
    character(len=24) :: nomprn
    character(len=24) :: option
    character(len=64) :: nochmd
    character(len=64) :: nomamd
    character(len=200) :: nofimd
    character(len=255) :: kfic
    integer :: typent, typgom
    integer, parameter :: edlect=0,ednoeu=3,edmail=0,ednoma=4,ednono=-1,typnoe=0
    character(len=1) :: saux01
    character(len=8) :: saux08
    character(len=8) :: nomgd
    integer :: numpt, numord, inum
    integer :: nbcmpv, iaux, itps0
    integer :: iinst
    real(kind=8) :: inst
    character(len=24) :: ncmpva, ncmpvm
    character(len=64) :: k64b
    aster_logical :: existm, logaux
    character(len=24), pointer :: refe(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    nomprn = resu//'.PRFCN00000.PRNO'
    resu19 = resu
!
    call infmaj()
    call infniv(ifm, niv)
!
!     NOM DU FICHIER MED
    call ulisog(mfich, kfic, saux01)
    if (kfic(1:1) .eq. ' ') then
        call codent(mfich, 'G', saux08)
        nofimd = 'fort.'//saux08
    else
        nofimd = kfic(1:200)
    endif
!
    call as_med_open(fid, nofimd, edlect, iret)
    call as_mfinvr(fid, major, minor, rel, iret)
    if (major .lt. 3) then
        nochmd(33:64) = '                                '
    endif
    call as_mficlo(fid, iret)
!
    if (niv .gt. 1) then
        write(ifm,*) '<',nompro,'> NOM DU FICHIER MED : ',nofimd
    endif
!
    prefix = '&&'//nompro//'.MED'
    call jedetr(prefix//'.NUME')
    call jedetr(prefix//'.INST')
!      CALL JEDETC('V',PREFIX,1)
!
!         RECUPERATION DU NOMBRE DE PAS DE TEMPS DANS LE CHAMP
!         ----------------------------------------------------
    ifimed = 0
    if (typcha(1:2) .eq. 'NO') then
        typent = ednoeu
        typgom = typnoe
        call mdchin(nofimd, ifimed, nochmd, typent, typgom,&
                    prefix, npas, iret)
        if (npas .eq. 0) then
            call utmess('A', 'MED_95', sk=nochmd)
            goto 240
        endif
        call jeveuo(prefix//'.INST', 'L', ipas)
        call jeveuo(prefix//'.NUME', 'L', inum)
!
    else if (typcha(1:2).eq.'EL') then
        ifimed = 0
        call mdexpm(nofimd, ifimed, nomamd, existm, ndim,&
                    iret)
        call lrmtyp(nbtyp, nomtyp, nnotyp, typgeo, renumd,&
                    modnum, nuanom, numnoa)
        if (typcha(1:4) .eq. 'ELNO') then
            typent = ednoma
        else
            typent = edmail
        endif
!
        do letype = 1, nbtyp
            iaux = renumd(letype)
            typgom = typgeo(iaux)
            ifimed = 0
            call mdchin(nofimd, ifimed, nochmd, typent, typgom,&
                        prefix, npas, iret)
            if (npas .ne. 0) then
                call jeveuo(prefix//'.INST', 'L', ipas)
                call jeveuo(prefix//'.NUME', 'L', inum)
                goto 240
            endif
        end do
!
!         CAS PARTICULIER: LECTURE DU FICHIER MED DONT L'ENTITE
!         DES CHAMPS ELNO EST ENCORE 'MED_MAILLE'
        if (typcha(1:4) .eq. 'ELNO') then
            typent = edmail
            call utmess('A', 'MED_53', sk=nochmd)
            do letype = 1, nbtyp
                iaux = renumd(letype)
                typgom = typgeo(iaux)
                ifimed = 0
                call mdchin(nofimd, ifimed, nochmd, typent, typgom,&
                            prefix, npas, iret)
                if (npas .ne. 0) then
                    call jeveuo(prefix//'.INST', 'L', ipas)
                    call jeveuo(prefix//'.NUME', 'L', inum)
                    goto 240
                endif
            end do
        endif
!
    endif
240 continue
!
    if (acces .ne. 'TOUT_ORDRE') then
        npas0=nbordr
    else
        npas0=npas
    endif
!
!         DETERMINATION DES NUMEROS D'ORDRE MED : ZI(JNUOM)
    if (nnu .ne. 0) then
        call wkvect('&&OP0150_NUMORD_MED', 'V V I', npas, jnuom)
        do j = 1, npas
            if (zi(inum+2*j-1) .ne. ednono) then
                zi(jnuom+j-1)=zi(inum+2*j-1)
            else if (zi(inum+2*(j-1)).ne.ednono) then
                zi(jnuom+j-1)=zi(inum+2*(j-1))
            endif
        end do
    endif
!
    call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbma)
    call wkvect('&&OP0150_NBPG_MAILLE', 'V V I', nbma, jnbpgm)
    call wkvect('&&OP0150_NBPG_MED', 'V V I', nbma, jnbpmm)
    call wkvect('&&OP0150_NBSP_MED', 'V V I', nbma, jnbsmm)
!
!         BOUCLE SUR LES PAS DE TEMPS
!         ---------------------------
!     CET ENTIER SERT A AVOIR LA CERTITUDE QUE LE .ORDR PRODUIT
!     EN SORTIE DE LIRE_RESU SERA STRICTEMENT CROISSANT
    ordins = 1
    do itps = 1, npas0
        chanom = '&&LRFMED.TEMPOR'
        k64b = ' '
!
        if (nnu .ne. 0) then
            numord = zi(jnume+itps-1)
            itps0=indiis(zi(jnuom),numord,1,npas)
            if (itps0 .eq. 0) then
                call utmess('A', 'MED_87', sk=resu, si=numord)
                cycle
            endif
            numpt=zi(inum+2*itps0-2)
        else if (nto.ne.0) then
            numord = zi(inum+2*itps-1)
            numpt = zi(inum+2*itps-2)
        else if (nis.ne.0) then
            inst = zr(jlist+itps-1)
            logaux = .false.
            do iaux2 = 1 , npas0
                if (crit(1:4) .eq. 'RELA') then
                    if (abs(zr(ipas-1+iaux2)-inst) .le. abs(epsi*inst)) then
                        logaux = .true.
                    endif
                else if (crit(1:4).eq.'ABSO') then
                    if (abs(zr(ipas-1+iaux2)-inst) .le. abs(epsi)) then
                        logaux = .true.
                    endif
                endif
                if (logaux) then
                    numpt = zi(inum+2*iaux2-2)
                    numord = zi(inum+2*iaux2-1)
                    iinst = 0
                    exit
                endif
            end do
        endif
!
        call lrchme(chanom, nochmd, k64b, noma, typcha,&
                    nomgd, typent, nbcmpv, ncmpva, ncmpvm,&
                    prolz, iinst, numpt, numord, inst,&
                    crit, epsi, mfich, option, param,&
                    zi(jnbpgm), zi(jnbpmm), zi(jnbsmm), iret)
!
!         POUR LES CHAM_NO : POUR ECONOMISER L'ESPACE,
!         ON ESSAYE DE PARTAGER LE PROF_CHNO DU CHAMP CREE AVEC
!         LE PROF_CHNO PRECEDENT :
        if (typcha .eq. 'NOEU') then
            call dismoi('PROF_CHNO', chanom, 'CHAM_NO', repk=pchn1)
            if (.not.idensd('PROF_CHNO',nomprn(1:19),pchn1)) then
                call gnomsd(' ', nomprn, 15, 19)
                call copisd('PROF_CHNO', 'G', pchn1, nomprn)
            endif
            call jeveuo(chanom//'.REFE', 'E', vk24=refe)
            refe(2) = nomprn(1:19)
            call detrsd('PROF_CHNO', pchn1)
        endif
        if (numord .eq. ednono) then
            numord = numpt
        endif
        if (nis .ne. 0) then
            numord = ordins
            ordins = ordins + 1
        endif
!
        call rsexch(' ', resu, linoch(i), numord, nomch, iret)
        if (iret .eq. 100) then
        else if (iret.eq.110) then
            call rsagsd(resu, 0)
            call rsexch(' ', resu, linoch(i), numord, nomch, iret)
        else
            valk (1) = resu
            valk (2) = chanom
            vali (1) = itps
            vali (2) = iret
            call utmess('F', 'UTILITAI8_27', nk=2, valk=valk, ni=2,vali=vali)
        endif
        call copisd('CHAMP_GD', 'G', chanom, nomch)
        call rsnoch(resu, linoch(i), numord)
        call rsadpa(resu, 'E', 1, acce, numord, 0, sjv=jinst)
!
        if (nis .ne. 0) then
            zr(jinst) = inst
        else if (nnu.ne.0) then
            zr(jinst) = zr(ipas-1+itps0)
        else if (nto.ne.0) then
            zr(jinst) = zr(ipas-1+itps)
        endif
        call detrsd('CHAMP_GD', chanom)
    end do
    call jedetr('&&OP0150_NBPG_MAILLE')
    call jedetr('&&OP0150_NBPG_MED')
    call jedetr('&&OP0150_NBSP_MED')
    call jedetr(ncmpva)
    call jedetr(ncmpvm)
    call jedetr('&&OP0150_NUMORD_MED')
!
    call jedema()
!
end subroutine
