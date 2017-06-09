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

subroutine refe80(nomres)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 07/03/91
!-----------------------------------------------------------------------
!
!  BUT:  REMPLIR L'OBJET REFE ASSOCIE AU CALCUL CYCLIQUE
!
!-----------------------------------------------------------------------
!
! NOM----- / /:
!
! NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
!
!
!
!
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: nomres, basmod, intf, mailla
    character(len=10) :: typbas(3)
    character(len=24) :: blanc, idesc
    character(len=24) :: valk(3)
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: ioc1, iret, ldref
!-----------------------------------------------------------------------
    data typbas/'CLASSIQUE','CYCLIQUE','RITZ'/
!
!-----------------------------------------------------------------------
!
    call jemarq()
    blanc='   '
    basmod=blanc
!
!------------RECUPERATION DU NOMBRE D'OCCURENCES DES MOT-CLE------------
!
    call getvid(blanc, 'BASE_MODALE', iocc=1, scal=basmod, nbret=ioc1)
!
!------------------CONTROLE SUR TYPE DE BASE MODALE---------------------
!
    call dismoi('TYPE_BASE', basmod, 'RESU_DYNA', repk=idesc, arret='C',&
                ier=iret)
!
    if (idesc(1:9) .ne. 'CLASSIQUE') then
        valk (1) = basmod
        valk (2) = idesc
        valk (3) = typbas(1)
        call utmess('F', 'ALGORITH14_13', nk=3, valk=valk)
    endif
!
!--------------------RECUPERATION DES CONCEPTS AMONTS-------------------
!
    call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=intf)
    call dismoi('NOM_MAILLA', intf, 'INTERF_DYNA', repk=mailla)
!
!--------------------ALLOCATION ET REMPLISSAGE DU REFE------------------
!
    call wkvect(nomres//'.CYCL_REFE', 'G V K24', 3, ldref)
!
    zk24(ldref)=mailla
    zk24(ldref+1)=intf
    zk24(ldref+2)=basmod
!
!
    call jedema()
end subroutine
