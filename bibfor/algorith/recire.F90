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

subroutine recire(typopt, iderre, frexci, fremin, fremax,&
                  pas, nbptmd)
    implicit none
#include "asterc/getfac.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
    integer :: iderre, nbptmd
    real(kind=8) :: fremin, fremax, pas
    character(len=4) :: typopt, frexci
!
!  BUT: RECUPERER LES INFORMATIONS DU MOT CLE FACTEUR REPONSE POUR
!        LE CALCUL DYNAMIQUE ALEATOIRE
!
! OUT : TYPOPT : OPTION 'DIAG' OU 'TOUT'
! OUT : IDERRE : ORDRE DE DERIVATION
! OUT : FREXCI : FREQUENCE DE L EXCITATION: AVEC OU SANS
! OUT : FREMIN : FREQ MIN DE LA DISCRETISATION
! OUT : FREMAX : FREQ MAX DE LA DISCRETISATION
! OUT : PAS    : PAS DE LA DISCRETISATION
! OUT : NBPTMD : NOMBRE DE POINTS PAR MODES
!
!-----------------------------------------------------------------------
    integer :: ibid, nbocc
!-----------------------------------------------------------------------
!
    typopt = 'TOUT'
    iderre = 0
    frexci = 'AVEC'
    fremin = -1.d0
    fremax = -1.d0
    pas = -1.d0
    nbptmd = 50
!
    call getfac('REPONSE', nbocc)
!
    if (nbocc .ne. 0) then
!
!----TYPE DE REPONSE ET RELATIF/ABSOLU ET MONO/INTER
!
        call getvtx('REPONSE', 'OPTION', iocc=1, scal=typopt, nbret=ibid)
        call getvis('REPONSE', 'DERIVATION', iocc=1, scal=iderre, nbret=ibid)
!
!----INCLUSION DES FREQUENCES DEXCITATION DANS LA DISCRETISATION REPONSE
!
        call getvtx('REPONSE', 'FREQ_EXCIT', iocc=1, scal=frexci, nbret=ibid)
!-
!----FREQUENCE INITIALE
!
        call getvr8('REPONSE', 'FREQ_MIN', iocc=1, scal=fremin, nbret=ibid)
        if (ibid .ne. 0) frexci = 'SANS'
!
!----FREQUENCE FINALE
!
        call getvr8('REPONSE', 'FREQ_MAX', iocc=1, scal=fremax, nbret=ibid)
!
!----PAS DE LA DISCRETISATION
!
        call getvr8('REPONSE', 'PAS', iocc=1, scal=pas, nbret=ibid)
!
!----NOMBRE DE POINTS PAR MODES
!
        call getvis('REPONSE', 'NB_POIN_MODE', iocc=1, scal=nbptmd, nbret=ibid)
!
    endif
!
end subroutine
