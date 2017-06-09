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

subroutine nbptca(ligrel, option, param, obnbpt, obnbno)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "jeveux.h"
#include "asterfort/alchml.h"
#include "asterfort/celces.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/wkvect.h"
!
    character(len=*) :: ligrel, option, param, obnbpt, obnbno
! ------------------------------------------------------------------
! But: Creer l'objet obnbpt qui contiendra le nombre de points
!      de discretisation (pour les mailles d'un ligrel)
!      pour le cham_elem associe a un parametre d'une option.
!      Calcule egalement un objet contenant le nombre de noeuds des
!      mailles du ligrel.
! ------------------------------------------------------------------
!     arguments:
! ligrel  in/jxin  k19 : ligrel
! option  in       k16 : nom d'une option de calcul
! param   in       k8  : nom d'un parametre de option
! obnbpt  in/jxout k24 : objet qui contiendra les nombres de points
! obnbno  in/jxout k24 : objet qui contiendra les nombres de noeuds
! ------------------------------------------------------------------
! remarques :
!  cette routine peut etre utilisee par exemple pour determiner les
!  nombre de points de gauss d'un modele mecanique non-lineaire:
!  option = 'raph_meca' + param='pcontmr'
!
!  l'objet cree est un vecteur d'entiers dimensionne au nombre de
!  mailles du maillage : v(ima) : nbpt(maille_ima)
!  les mailles tardives sont ignorees.
!-----------------------------------------------------------------------
    integer :: iret, nbma, ima,  jnbpt, jnbno, iacnx1, ilcnx1, nbno
    character(len=8) :: ma
    character(len=19) :: cel, ces
    integer, pointer :: cesd(:) => null()
!------------------------------------------------------------------
    call jemarq()
    cel = '&&NBPTCA.CEL'
    ces = '&&NBPTCA.CES'

    call dismoi('NOM_MAILLA', ligrel, 'LIGREL', repk=ma)
    call dismoi('NB_MA_MAILLA', ma, 'MAILLAGE', repi=nbma)
    call wkvect(obnbpt, 'V V I', nbma, jnbpt)
    call wkvect(obnbno, 'V V I', nbma, jnbno)
    call jeveuo(ma//'.CONNEX', 'L', iacnx1)
    call jeveuo(jexatr(ma//'.CONNEX', 'LONCUM'), 'L', ilcnx1)

    call alchml(ligrel, option, param, 'V', cel,&
                iret, ' ')
    if (iret .ne. 0) then
!       - IL N'Y A RIEN A FAIRE : NBPT(IMA)=0
    else
        call celces(cel, 'V', ces)
        call jeveuo(ces//'.CESD', 'L', vi=cesd)
        do ima = 1, nbma
            zi(jnbpt-1+ima) = cesd(5+4* (ima-1)+1)
            nbno = zi(ilcnx1+ima) - zi(ilcnx1-1+ima)
            zi(jnbno-1+ima) = nbno
        end do

    endif


    call detrsd('CHAM_ELEM', cel)
    call detrsd('CHAM_ELEM_S', ces)

    call jedema()
end subroutine
