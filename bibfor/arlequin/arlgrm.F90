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

subroutine arlgrm(mail  ,nomgrp,dime  ,ima  ,connex,loncum, &
                  nummai,nommai,itypm ,nbno , cxno)


! ROUTINE ARLEQUIN

! DONNE LES COORDONNEES D'UNE MAILLE D'UN GROUPE

! ----------------------------------------------------------------------


! IN  NOMGRP : NOM DU GROUPE DE MAILLES ARLEQUIN
! IN  MAIL   : NOM DU MAILLAGE
! IN  NOM    : NOM DE LA SD DE STOCKAGE DES MAILLES ARLEQUIN GROUP_MA_*
! IN  DIME   : DIMENSION DE L'ESPACE
! IN  IMA    : NUMERO D'ORDRE DE LA MAILLE DANS LE GROUPE ARLEQUIN
! IN  CONNEX : CONNEXITE DES MAILLES
! IN  LONCUM : LONGUEUR CUMULEE DE CONNEX
! OUT NUMMAI : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
! OUT NOMMAI : NOM DE LA MAILLE
! OUT ITYPM  : NUMERO ABSOLU DU TYPE DE LA MAILLE
! OUT NBNO   : NOMBRE DE NOEUDS DE LA MAILLE
! OUT CXNO   : CONNECTIVITE DE LA MAILLE
!                CONTIENT NUMEROS ABSOLUS DES NOEUDS DANS LE MAILLAGE
! ----------------------------------------------------------------------

    implicit none

#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/arlcnn.h"
#include "asterfort/jedema.h"

!     ARGUMENTS:
!     ----------
    character(len=19) :: nomgrp
    character(len=8) :: mail
    integer :: ima,dime
    integer :: connex(*),loncum(*)
    integer :: nummai
    character(len=8) :: nommai
    integer :: nbno,itypm
    integer :: cxno(27)
!-----------------------------------------------------------------------
    integer :: jgrp,jtyp,aima
!-----------------------------------------------------------------------

    call jemarq()

! --- INITIALISATIONS

    ASSERT((dime.gt.0).and.(dime.le.3))
    aima = abs(ima)

! --- LECTURE DONNEES MAILLAGE

    call jeveuo(mail(1:8)//'.TYPMAIL        ','L',jtyp)

! --- LECTURE DONNEES GROUPE DE MAILLES

    call jeveuo(nomgrp(1:19),'L',jgrp)

! --- NUMERO ABSOLU ET NOM DE LA MAILLE

    nummai = zi(jgrp-1+aima)
    call jenuno(jexnum(mail(1:8)//'.NOMMAI',nummai),nommai)

! --- TYPE DE LA MAILLE

    itypm  = zi(jtyp-1+nummai)

! --- CONNECTIVITE DE LA MAILLE

    call arlcnn(nummai,connex,loncum,nbno,cxno)

    call jedema()

end subroutine
