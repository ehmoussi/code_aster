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

subroutine ccbcop(resuin, resuou, lisord, nbordr, lisopt,&
                  nbropt)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/calcop.h"
#include "asterfort/ccfnrn.h"
#include "asterfort/ccvrch.h"
#include "asterfort/dismoi.h"
#include "asterfort/indk16.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/medom1.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsnopa.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
    integer :: nbordr, nbropt
    character(len=8) :: resuou, resuin
    character(len=19) :: lisord, lisopt
! person_in_charge: nicolas.sellenet at edf.fr
! ----------------------------------------------------------------------
!  CALC_CHAMP - BOUCLE SUR LA LISTE D'OPTION ET APPEL A CALCOP
!  -    -       -  -                  --
! ----------------------------------------------------------------------
!
!  ROUTINE PREPARANT L'APPEL A CALCOP
!
! IN  :
!   RESUIN K8   NOM DE LA SD IN
!   RESUOU K8   NOM DE LA SD OUT
!   LISORD K19  NOM DE LA LISTE DES NUMEROS D'ORDRE
!   NBORDR I    NOMBRE DE NUMEROS D'ORDRE
!   LISOOP K19  NOM DE LA LISTE DES OPTIONS A CALCULER
!   NBROPT I    LONGUEUR DE LA LISTE D'OPTIONS
! ----------------------------------------------------------------------
    character(len=6) :: nompro
    parameter  (nompro='CCBCOP')
!
    integer :: jordr, iret, nbchar, posopt
    integer :: ifm, niv, nuord
    integer :: nbac, nbpa, nbpara, jpara
    integer :: iaux, j, iadou, iadin, iordr, jopt, iopt
!
    character(len=4) :: typcha
    character(len=8) :: type, modele, carael
    character(len=8) :: k8b
    character(len=16) :: option, typesd
    character(len=19) :: lischa
    character(len=24) :: nompar, chmate
!
    aster_logical :: exipla, newcal, lforc_noda
!
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
!
    call gettco(resuin, typesd)
!
    lischa = '&&'//nompro//'.CHARGES   '
!
    newcal = .false.
    call jeexin(resuou//'           .DESC', iret)
    if (iret .eq. 0) newcal = .true.
!
    if ((resuin.ne.resuou) .and. (.not.newcal)) then
        call utmess('F', 'CALCULEL_18')
    endif
!
    call jeveuo(lisord, 'L', jordr)
    nuord = zi(jordr)
!
    call medom1(modele, chmate, carael, lischa, nbchar,&
                typcha, resuin, nuord)
    if (modele .eq. ' ') then
        call utmess('F', 'CALCULEL2_44')
    endif
!
!     RECUPERATION DE LA LISTE DE NUMEROS D'ORDRE
    if (newcal) then
        call rscrsd('G', resuou, typesd, nbordr)
        call titre()
    endif
!
!     ON VERIFIE QUE CARA_ELEM EST RENSEIGNES POUR LES COQUES
    exipla=.false.
    call dismoi('EXI_COQ1D', modele, 'MODELE', repk=k8b)
    if (k8b(1:3) .eq. 'OUI') exipla=.true.
    call dismoi('EXI_COQ3D', modele, 'MODELE', repk=k8b)
    if (k8b(1:3) .eq. 'OUI') exipla=.true.
    call dismoi('EXI_PLAQUE', modele, 'MODELE', repk=k8b)
    if (k8b(1:3) .eq. 'OUI') exipla=.true.
!
    if (exipla .and. carael .eq. ' ') then
        call utmess('A', 'CALCULEL2_94')
        goto 30
    endif
!
!     RECOPIE DES PARAMETRES DANS LA NOUVELLE SD RESULTAT
    if (newcal) then
        nompar='&&'//nompro//'.NOMS_PARA '
        call rsnopa(resuin, 2, nompar, nbac, nbpa)
        nbpara=nbac+nbpa
!
        call jeveuo(nompar, 'L', jpara)
        do iaux = 1, nbordr
            iordr=zi(jordr+iaux-1)
            do j = 1, nbpara
                call rsadpa(resuin, 'L', 1, zk16(jpara+j-1), iordr,&
                            1, sjv=iadin, styp=type, istop=0)
                call rsadpa(resuou, 'E', 1, zk16(jpara+j-1), iordr,&
                            1, sjv=iadou, styp=type)
!
                if (type(1:1) .eq. 'I') then
                    zi(iadou)=zi(iadin)
                else if (type(1:1).eq.'R') then
                    zr(iadou)=zr(iadin)
                else if (type(1:1).eq.'C') then
                    zc(iadou)=zc(iadin)
                else if (type(1:3).eq.'K80') then
                    zk80(iadou)=zk80(iadin)
                else if (type(1:3).eq.'K32') then
                    zk32(iadou)=zk32(iadin)
                else if (type(1:3).eq.'K24') then
                    zk24(iadou)=zk24(iadin)
                else if (type(1:3).eq.'K16') then
                    zk16(iadou)=zk16(iadin)
                else if (type(1:2).eq.'K8') then
                    zk8(iadou)=zk8(iadin)
                endif
            end do
        end do
        call jedetr(nompar)
    endif
!
    call jeveuo(lisopt, 'L', jopt)
!
!     VERIFICATION DE LA PRESENCE D'UN EXCIT DANS LE FICHIER
!     DE COMMANDE OU DES CHARGES DANS LA SD RESULTAT
    posopt = indk16(zk16(jopt), 'FORC_NODA', 1, nbropt)
    lforc_noda = .true.
    if (posopt.eq.0) lforc_noda = .false.
    call ccvrch(resuin, zi(jordr), lforc_noda)
!
!     BOUCLE SUR LES OPTIONS DEMANDEES PAR L'UTILISATEUR
    do iopt = 1, nbropt
!
        option=zk16(jopt+iopt-1)
        if (option .eq. ' ') goto 20
!
        if ((option.eq.'FORC_NODA') .or. (option.eq.'REAC_NODA')) then
            call ccfnrn(option, resuin, resuou, lisord, nbordr,&
                        typcha, typesd)
            if((option.eq.'REAC_NODA') .and. &
                  ((typesd.eq.'DYNA_TRANS') .or. &
                   (typesd.eq.'DYNA_HARMO'))) then
                call utmess('A', 'CALCCHAMP_4')
            endif
        else
            call calcop(option, lisopt, resuin, resuou, lisord,&
                        nbordr, typcha, typesd, iret)
!
            if (iret .ne. 0) then
                ASSERT(.false.)
            endif
        endif
 20     continue
    end do
!
 30 continue
!
    call jedema()
!
end subroutine
