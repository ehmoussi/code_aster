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

subroutine alchlo(nin, lpain, nout, lpaout)
use calcul_module, only : ca_iaobtr_, ca_iaoppa_, ca_iawlo2_, ca_iawloc_,&
                          ca_iawtyp_, ca_igr_, ca_nbgr_, ca_nbobtr_,&
                          ca_npario_, ca_ligrel_, ca_nuop_
implicit none

! person_in_charge: jacques.pellet at edf.fr
!     arguments:
!     ----------
#include "jeveux.h"

#include "asterc/indik8.h"
#include "asterfort/dchlmx.h"
#include "asterfort/grdeur.h"
#include "asterfort/mecoe1.h"
#include "asterfort/scalai.h"
#include "asterfort/typele.h"
#include "asterfort/wkvect.h"
    integer :: nin, nout
    character(len=8) :: lpain(nin), lpaout(nout)
! ----------------------------------------------------------------------
!     entrees:

!     sorties:
!     creation des champs locaux de noms &&CALCUL.NOMPAR(OPT)
!     le champ local est une zone memoire temporaire a la routine calcul
!     qui contiendra les  valeurs des champs "bien rangees"
!     (pour les te00ij) de tous les elements d'un grel.
!-----------------------------------------------------------------------
    integer :: iparg, taille, gd
    integer ::  iparin, iparou, nute
    character(len=24) :: nochl, nochl2
    character(len=8) :: nompar
    character(len=8) :: scal
!-----------------------------------------------------------------------

    call wkvect('&&CALCUL.IA_CHLOC', 'V V I', 3*ca_npario_, ca_iawloc_)
    call wkvect('&&CALCUL.IA_CHLO2', 'V V I', 5*ca_npario_*ca_nbgr_, ca_iawlo2_)
    call wkvect('&&CALCUL.TYPE_SCA', 'V V K8', ca_npario_, ca_iawtyp_)
    ca_nbobtr_ = ca_nbobtr_ + 1
    zk24(ca_iaobtr_-1+ca_nbobtr_) = '&&CALCUL.IA_CHLOC'
    ca_nbobtr_ = ca_nbobtr_ + 1
    zk24(ca_iaobtr_-1+ca_nbobtr_) = '&&CALCUL.IA_CHLO2'
    ca_nbobtr_ = ca_nbobtr_ + 1
    zk24(ca_iaobtr_-1+ca_nbobtr_) = '&&CALCUL.TYPE_SCA'


!   -- initialisation de '&&CALCUL.IA_CHLO2':
    do ca_igr_ = 1, ca_nbgr_
        nute=typele(ca_ligrel_,ca_igr_,1)
        call mecoe1(ca_nuop_, nute)
    enddo


    do iparg = 1, ca_npario_
        nompar = zk8(ca_iaoppa_-1+iparg)
        nochl = '&&CALCUL.'//nompar
        nochl2= '&&CALCUL.'//nompar//'.EXIS'
        zi(ca_iawloc_-1+3*(iparg-1)+1)=-1
        zi(ca_iawloc_-1+3*(iparg-1)+2)=-1

!       Si le parametre n'est associe a aucun champ, on passe :
!       --------------------------------------------------------
        iparin = indik8(lpain,nompar,1,nin)
        iparou = indik8(lpaout,nompar,1,nout)
        zi(ca_iawloc_-1+3*(iparg-1)+3)=iparin+iparou
        if ((iparin+iparou) .eq. 0) cycle

        gd = grdeur(nompar)
        scal = scalai(gd)
        zk8(ca_iawtyp_-1+iparg) = scal
        call dchlmx(iparg, nin, lpain, nout, lpaout, taille)
        if (taille .ne. 0) then
            call wkvect(nochl, 'V V '//scal(1:4), taille, zi(ca_iawloc_-1+3* (iparg-1)+1))
            ca_nbobtr_ = ca_nbobtr_ + 1
            zk24(ca_iaobtr_-1+ca_nbobtr_) = nochl
            if (iparin .gt. 0) then
                call wkvect(nochl2, 'V V L', taille, zi(ca_iawloc_-1+3*( iparg-1)+2))
                ca_nbobtr_ = ca_nbobtr_ + 1
                zk24(ca_iaobtr_-1+ca_nbobtr_) = nochl2
            endif
        else
            zi(ca_iawloc_-1+3*(iparg-1)+1)=-2
        endif
    end do

end subroutine
