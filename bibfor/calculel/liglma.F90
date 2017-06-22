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

subroutine liglma(ligrel, nbma, linuma, linute)
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
    character(len=*) :: linuma, linute
    character(len=19) :: ligrel
    integer :: nbma
!
! ----------------------------------------------------------------------
! but : extraction d'un ligrel de la liste des numeros de mailles et
!       de la liste des numeros de type_element
!
! in/jxin  ligrel  : ligrel
! out      nbma    : nombre de mailles affectees dans le ligrel
!                    = dimension des objets linuma et linute
! in/jxout linuma  : objet (v i) qui contiendra les numeros des mailles
!                    associees aux elements du ligrel
! in/jxout linute  : objet (v i) qui contiendra les numeros des
!                    type_element associes aux elements du ligrel
! ----------------------------------------------------------------------
    integer :: nbgrel, igrel, iel, numa, nute, n1, nbel
    integer :: jnuma, jnute, ico, jliel
!
! ----------------------------------------------------------------------
    call jemarq()
!
    call jelira(ligrel//'.LIEL', 'NMAXOC', nbgrel)

!   -- calcul de nbma :
    nbma=0
    do igrel=1,nbgrel
        call jelira(jexnum(ligrel//'.LIEL', igrel), 'LONMAX', n1)
        nbel=n1-1
        nbma=nbma+nbel
    end do
    ASSERT(nbma.gt.0)


!    -- calcul de linuma et linute :
    call wkvect(linuma, 'V V I', nbma, jnuma)
    call wkvect(linute, 'V V I', nbma, jnute)

    ico=0
    do igrel=1,nbgrel
        call jelira(jexnum(ligrel//'.LIEL', igrel), 'LONMAX', n1)
        call jeveuo(jexnum(ligrel//'.LIEL', igrel), 'L', jliel)
        nbel=n1-1
        nute=zi(jliel-1+n1)
        do iel=1,nbel
            ico=ico+1
            numa=zi(jliel-1+iel)
            zi(jnuma-1+ico)=numa
            zi(jnute-1+ico)=nute
        enddo
    end do

    call jedema()
end subroutine
