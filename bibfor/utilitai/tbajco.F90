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

subroutine tbajco(nomta, para, type, nbval, vi,&
                  vr, vc, vk, action, llign)
    implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/tbajpa.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    integer :: nbval, vi(*), llign(*)
    real(kind=8) :: vr(*)
    complex(kind=8) :: vc(*)
    character(len=*) :: nomta, para, type, vk(*), action
!
!      AJOUTER OU REMPLIR  UNE COLONNE DANS UNE TABLE.
! ----------------------------------------------------------------------
! IN  : NOMTA   : NOM DE LA STRUCTURE "TABLE".
! IN  : PARA    : NOM DU PARAMETRE
! IN  : NBVAL   : NOMBRE DE VALEUR A RENTRER
! IN  : TYPE    : TYPE DU PARAMETRE D ENTREE
! IN  : VI      : LISTE DES VALEURS POUR LES PARAMETRES "I"
! IN  : VR      : LISTE DES VALEURS POUR LES PARAMETRES "R"
! IN  : VC      : LISTE DES VALEURS POUR LES PARAMETRES "C"
! IN  : VK      : LISTE DES VALEURS POUR LES PARAMETRES "K"
! IN  : ACTION  : TYPE D ACTION A ENTREPRENDRE
!                  'A' ON AJOUTE UNE COLONNE
!                  'R' ON REMPLIT UNE COLONNE EXISTANTE
! IN  : LLIGN   : LISTE DES INDICES DE LIGNES A AJOUTER EFFECTIVEMENT
!                 SI PREMIERE VALEUR =-1, ON AJOUTE SANS DECALAGE
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: i, iret,   nbpara, jvale, jlogq, nblign, iind
    character(len=1) :: actioz
    character(len=3) :: typez, typev
    character(len=19) :: nomtab
    character(len=24) :: nomjv, nomjvl, paraz, indic
    integer, pointer :: tbnp(:) => null()
    character(len=24), pointer :: tblp(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
    indic='&&TABJCO.IND'
    call wkvect(indic, 'V V I', nbval, iind)
    nomtab=' '
    nomtab=nomta
    typez=' '
    typez=type
    actioz=action
    paraz=' '
    paraz=para
!
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_64')
    endif
    if (nomtab(18:19) .ne. '  ') then
        call utmess('F', 'UTILITAI4_68')
    endif
!
    if (actioz .eq. 'A') then
        call tbajpa(nomtab, 1, para, typez)
    endif
!
    call jeveuo(nomtab//'.TBLP', 'L', vk24=tblp)
    call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
!
    nbpara=tbnp(1)
    nblign=tbnp(2)
    if (nbpara .eq. 0) then
        call utmess('F', 'UTILITAI4_65')
    endif
!
    if (nbval .gt. nblign) then
        call utmess('F', 'UTILITAI4_69')
    endif
!
    if (llign(1) .ne. -1) then
        do 10 i = 1, nbval
            zi(iind+i-1)=llign(i)
            if (llign(i) .le. 0) then
                call utmess('F', 'UTILITAI4_70')
            endif
            if (llign(i) .gt. nblign) then
                call utmess('F', 'UTILITAI4_71')
            endif
10      continue
    else
        do 20 i = 1, nbval
            zi(iind+i-1)=i
20      continue
    endif
!
!  --- RECHERCHE DES NOMS JEVEUX DU PARAMETRE
    iret=0
    do i = 1, nbpara
        if (paraz .eq. tblp(1+(4*(i-1)))) then
            nomjv=tblp(1+(4*(i-1)+2))
            nomjvl=tblp(1+(4*(i-1)+3))
            typev=tblp(1+(4*(i-1)+1))(1:3)
            iret=1
        endif
    end do
!
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_72')
    endif
!
    if (typev .ne. typez) then
        call utmess('F', 'UTILITAI4_73')
    endif
!
    call jeecra(nomjv, 'LONUTI', nblign)
     call jeecra(nomjvl, 'LONUTI', nblign)
    call jeveuo(nomjv, 'E', jvale)
    call jeveuo(nomjvl, 'E', jlogq)
!
!  --- REMPLISSAGE DES CELLULES DE LA COLONNE
!
    do i = 1, nbval
!
        if (typez(1:1) .eq. 'I') then
            zi(jvale+zi(iind+i-1)-1) = vi(i)
            zi(jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:1) .eq. 'R') then
            zr(jvale+zi(iind+i-1)-1) = vr(i)
            zi(jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:1) .eq. 'C') then
            zc(jvale+zi(iind+i-1)-1) = vc(i)
            zi(jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:3) .eq. 'K80') then
            zk80(jvale+zi(iind+i-1)-1) = vk(i)
            zi( jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:3) .eq. 'K32') then
            zk32(jvale+zi(iind+i-1)-1) = vk(i)
            zi( jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:3) .eq. 'K24') then
            zk24(jvale+zi(iind+i-1)-1) = vk(i)
            zi( jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:3) .eq. 'K16') then
            zk16(jvale+zi(iind+i-1)-1) = vk(i)
            zi( jlogq+zi(iind+i-1)-1) = 1
        else if (typez(1:2) .eq. 'K8') then
            zk8(jvale+zi(iind+i-1)-1) = vk(i)
            zi( jlogq+zi(iind+i-1)-1) = 1
        endif
    end do
    
    call jedetr(indic)
    call jedema()
end subroutine
