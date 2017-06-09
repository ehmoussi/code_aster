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

subroutine xmrlst(jcesd, jcesv, jcesl, noma, posma,&
                  coor, lst)
!
! person_in_charge: patrick.massin at edf.fr
!
!
    implicit none
!
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/elrfvf.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
    character(len=8) :: noma
    integer :: jcesd(10), jcesv(10), jcesl(10)
    integer :: posma
    real(kind=8) :: coor(3), lst
!
!-----------------------------------------------------------------------
!
! ROUTINE XFEM (CONTACT - GRANDS GLISSEMENTS)
!
! CALCUL DE LA LST AU POINT D'INTEGRATION D'UN ELEMENT DONNEE
! SERT ENSUITE DANS LES TE POUR LES POINTES DE FISSURES
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
!  JCES*(7)  : POINTEURS DE LA SD SIMPLE DE LA LEVEL SET TANGENTE
! IN  NOMA   : NOM DU MAILLAGE
! IN  POSMA  : POSITION DE LA MAILLE ESCLAVE OU MAITRE
! IN  COOR   : COORDONNEES DU POINT DANS L'ELEMENT PARENT
! OUT  LST   : LEVEL SET TANGENTE AU POINT D'INTEGRATION
!
!
!
!
    real(kind=8) :: ff(20)
    integer :: jconx1, jconx2, jma
    integer :: itypma, nno, ino, iad
    character(len=8) :: typma, elref
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ON RECUPERE LA CONNECTIVITE DU MAILLAGE
!
    call jeveuo(noma//'.CONNEX', 'L', jconx1)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
!
    call jeveuo(noma//'.TYPMAIL', 'L', jma)
!
! --- ON RECUPERE LE TYPE DE LA MAILLE
!
    call jeveuo(noma//'.TYPMAIL', 'L', jma)
    itypma=zi(jma-1+posma)
    call jenuno(jexnum('&CATA.TM.NOMTM', itypma), typma)
    if (typma .eq. 'HEXA8') elref = 'HE8'
    if (typma .eq. 'PENTA6') elref = 'PE6'
    if (typma .eq. 'TETRA4') elref = 'TE4'
    if (typma .eq. 'HEXA20') elref = 'H20'
    if (typma .eq. 'PENTA15') elref = 'P15'
    if (typma .eq. 'TETRA10') elref = 'T10'
    if (typma(1:4) .eq. 'QUAD') elref = 'QU4'
    if (typma(1:4) .eq. 'TRIA') elref = 'TR3'
!
! --- ON RECUPERE LE NOMBRE DE NOEUDS DE LA MAILLE
!
    call jelira(jexnum(noma//'.CONNEX', posma), 'LONMAX', nno)
!
! --- FONCTIONS DE FORMES DU PT DE CONTACT DANS L'ELE PARENT
!
    call elrfvf(elref, coor, nno, ff, nno)
!
! --- ON INTERPOLE LA LST AVEC SES VALEURS AUX NOEUDS
!
!
    lst = 0.d0
    do 10 ino = 1, nno
        call cesexi('C', jcesd(7), jcesl(7), posma, ino,&
                    1, 1, iad)
        ASSERT(iad.gt.0)
        lst = lst + zr(jcesv(7)-1+iad) * ff(ino)
10  end do
    lst = sqrt(abs(lst))
!
    call jedema()
end subroutine
