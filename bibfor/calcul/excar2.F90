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

subroutine excar2(ngrmx, desc, dg, ncmp, debugr)

use calcul_module, only : ca_iachii_, ca_ialiel_, ca_igr_, ca_iichin_, &
    ca_illiel_, ca_nbelgr_, ca_ncmpmx_, ca_nec_, ca_iel_, ca_paral_, ca_lparal_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/trigd.h"

    integer :: ngrmx, desc, dg(*), ncmp
!-------------------------------------------------------------------------
! but : recopier dans le champ local, les cmps de la carte correspondant
!       au descripteur_grandeur dg
!-------------------------------------------------------------------------
    integer :: ptma, ptms, ient, ima, deb2
    integer :: debgd, indval, debugr
!    -- fonctions formules :
!    numail(igr,iel)=numero de la maille associee a l'element iel
#define numail(ca_igr_,ca_iel_) zi(ca_ialiel_-1+zi(ca_illiel_-1+ca_igr_)-1+ca_iel_)
!--------------------------------------------------------------------------


!   Si la carte est constante:
!   --------------------------
    if (ngrmx .eq. 1 .and. zi(desc-1+4) .eq. 1) then
        debgd = 3 + 2*ngrmx + 1
        deb2 = debugr
        do ca_iel_ = 1, ca_nbelgr_
            if (ca_lparal_) then
                if (.not.ca_paral_(ca_iel_)) then
                    deb2=deb2+ncmp
                    cycle
                endif
            endif
            call trigd(zi(desc-1+debgd), 1, dg, deb2, .false._1, 0, 0)
        enddo
        goto 999
    endif


!   Si la carte n'est pas constante :
!   ---------------------------------
    ptma = zi(ca_iachii_-1+11* (ca_iichin_-1)+6)
    ptms = zi(ca_iachii_-1+11* (ca_iichin_-1)+7)

    deb2 = debugr
    do ca_iel_ = 1, ca_nbelgr_
        if (ca_lparal_) then
            if (.not.ca_paral_(ca_iel_)) then
                deb2=deb2+ncmp
                cycle
            endif
        endif
!       recherche du numero de l'entite correspondant a la maille ima:
        ima = numail(ca_igr_,ca_iel_)
        if (ima .lt. 0) then
            ient = zi(ptms-1-ima)
        else
            ient = zi(ptma-1+ima)
        endif
        if (ient .eq. 0) then
            deb2=deb2+ncmp
            cycle
        endif

!       recopie:
!       -------
        debgd = 3 + 2*ngrmx + (ient-1)*ca_nec_ + 1
        indval = (ient-1)*ca_ncmpmx_ + 1

        call trigd(zi(desc-1+debgd), indval, dg, deb2, .false._1, 0, 0)
    end do

999 continue

end subroutine
