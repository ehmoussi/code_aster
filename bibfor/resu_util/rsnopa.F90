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

subroutine rsnopa(nomsd, icode, nomjv, nbacc, nbpara)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: icode, nbacc, nbpara
    character(len=*) :: nomsd, nomjv
!      RECUPERATION DU NOMBRE DE VARIABLES D'ACCES ET DU NOMBRE
!      DE PARAMETRES D'UN RESULTAT AINSI QUE DE LEUR NOMS
!      (STOCKES DANS LA STRUCTURE JEVEUX DE NOM NOMJV)
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT".
! IN  : NOMJV  : NOM DE LA STRUCTURE JEVEUX POUR ECRIRE LA LISTE DES
!                NOMS DE PARAMETRES
! IN  : ICODE  : CODE = 0 : VARIABLES D'ACCES SEULES
!                     = 1 : PARAMETRES SEULS
!                     = 2 : TOUT
! OUT : NBACC  : NOMBRE DE VARIABLES D'ACCES
! OUT : NBPARA : NOMBRE DE PARAMETRES
!
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    character(len=16) :: nompar
    character(len=19) :: nomd2
! ----------------------------------------------------------------------
!
!  --- INITIALISATIONS ---
!
!-----------------------------------------------------------------------
    integer :: iacc, iatava, ibid, ipar, iret
    integer :: jpara, nbpar
    character(len=16), pointer :: nom_acce(:) => null()
    character(len=16), pointer :: nom_para(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    nomd2 = nomsd
    nbpara = 0
    nbacc = 0
!
    call jelira(nomd2//'.NOVA', 'NOMMAX', nbpar)
    if (nbpar .ne. 0) then
        AS_ALLOCATE(vk16=nom_acce, size=nbpar)
        AS_ALLOCATE(vk16=nom_para, size=nbpar)
        do 30 ipar = 1, nbpar
            call jenuno(jexnum(nomd2//'.NOVA', ipar), nompar)
            call jenonu(jexnom(nomd2//'.NOVA', nompar), ibid)
            call jeveuo(jexnum(nomd2//'.TAVA', ibid), 'L', iatava)
            if (zk8(iatava+3)(1:4) .eq. 'PARA') then
                nbpara = nbpara + 1
                nom_para(nbpara) = nompar
            else
                nbacc = nbacc + 1
                nom_acce(nbacc) = nompar
            endif
30      continue
        if (icode .eq. 0) nbpara = 0
        if (icode .eq. 1) nbacc = 0
        call jeexin(nomjv, iret)
        if (iret .ne. 0) call jedetr(nomjv)
        if (icode .eq. 0 .and. nbacc .eq. 0) then
            call utmess('A', 'UTILITAI4_44')
        endif
        if (icode .eq. 1 .and. nbpara .eq. 0) then
            call utmess('A', 'UTILITAI4_45')
        endif
        if ((nbacc+nbpara) .ne. 0) then
            call wkvect(nomjv, 'V V K16', (nbacc+nbpara), jpara)
            if (nbacc .ne. 0) then
                do 40 iacc = 1, nbacc
                    zk16(jpara-1+iacc) = nom_acce(iacc)
40              continue
            endif
            if (nbpara .ne. 0) then
                do 50 ipar = 1, nbpara
                    zk16(jpara-1+ipar+nbacc) = nom_para(ipar)
50              continue
            endif
        endif
        AS_DEALLOCATE(vk16=nom_acce)
        AS_DEALLOCATE(vk16=nom_para)
    else
!        -- RIEN A FAIRE
    endif
!
!
    call jedema()
end subroutine
