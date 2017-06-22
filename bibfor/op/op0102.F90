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

subroutine op0102()
    implicit none
!
!      OPERATEUR :     CALC_CHAR_CINE
!
!
! ----------DECLARATIONS
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/calvci.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: ibid
    character(len=8) :: vcine, nomgd, nomgds
    character(len=14) :: nomnu
    character(len=16) :: type, oper
!
! --------- FONCTIONS EXTERNES
!
!
!
    real(kind=8) :: inst
!
!
!-----------------------------------------------------------------------
    integer :: ilichc, inume, nbchci
!-----------------------------------------------------------------------
    call jemarq()
!
    call infmaj()
!
! --- RECUPERATION DES ARGUMENTS DE LA COMMANDE
!
    call getres(vcine, type, oper)
!
! --- INST DE CALCUL
!
    call getvr8(' ', 'INST', scal=inst, nbret=ibid)
!
! --- NUME_DDL
!
    call getvid(' ', 'NUME_DDL', scal=nomnu, nbret=inume)
!
! --- CHAR_CINE
!
    call getvid(' ', 'CHAR_CINE', nbval=0, nbret=nbchci)
    nbchci = -nbchci
    call wkvect(vcine//'.&&LICHCIN', 'V V K8', nbchci, ilichc)
    call getvid(' ', 'CHAR_CINE', nbval=nbchci, vect=zk8(ilichc), nbret=ibid)
!
! --- VERIF SUR LES GRANDEURS  GD ASSOCIEE AU NUME_DDL, GD ASSOCIEE AU
!     VCINE
    call dismoi('NOM_GD', nomnu, 'NUME_DDL', repk=nomgd)
    call dismoi('NOM_GD_SI', nomgd, 'GRANDEUR', repk=nomgds)
!
! --- CREATION DU CHAMNO ET AFFECTATION DU CHAMNO
    call calvci(vcine, nomnu, nbchci, zk8(ilichc), inst,&
                'G')
!
!
    call jedema()
end subroutine
