\name{haplotype-analysis-methods}
\alias{loadHaplotypeAlleleCounts}


\title{
  Function to load tumour allele counts from a text file or data.frame and returns a \link[data.table]{data.table}.
}

\description{
  Function to load in the allele counts from tumour sequencing data from a delimited text file or data.frame object.
}

\usage{
    loadHaplotypeAlleleCounts(inCounts, fun = "sum", haplotypeBinSize = 1e5, 
      minSNPsInBin = 3, chrs = c(1:22, "X"), minNormQual = 200, 
      genomeStyle = "NCBI", sep = "\t", header = TRUE, seqinfo = NULL)
}

\arguments{
  \item{inCounts}{
    Full file path to text file or data.frame containing tumour allele count data. \code{inCounts} must be 6 columns: chromosome, position, reference base, reference read counts, non-reference base, non-reference read counts.  \sQuote{chromosome} column can be in \sQuote{NCBI} or \sQuote{UCSC} genome style; only autosomes, sex chromosomes, and mitochondrial chromosome are included (e.g. 1-22,X,Y,MT). The reference and non-reference base columns can be any arbitrary character; it is not used by \pkg{TitanCNA}.
  }
  \item{fun}{
    The function (\sQuote{SNP}, \sQuote{sum}, \sQuote{mean}) to use to summarize within each user defined bin using \code{haplotypeBinSize} and haplotype block defined by the phaseSet ID from thte 9th column of \code{inCounts}. 
    \sQuote{SNP} - uses the phased allele counts each individual SNP; phased allele for the higher coverage (determined within each bin) haplotype is chosen. 
    \sQuote{sum} - uses the read count sum across all phased SNPs for the higher coverage haplotype within a bin normalized by the total depth across all SNPs in a bin; each SNP in the bin is assigned this fraction. 
    \sQuote{mean} - uses the mean (rounded) read count across all phased SNPs for the higher coverage haplotype within a bin normalized by the mean (rounded) depth across all SNPs in a bin; each SNP in the bin is assigned this rounded count and depth.
  }
  \item{haplotypeBinSize}{
    Bin size used to summarize SNPs based on phased haplotypes.  See \code{fun} for the summarization approaches within a bin.
  }
  \item{minSNPsInBin}{
    The minimum number of SNPs required in each \code{haplotypeBinSize} for analysis. See \code{fun} for the summarization approaches within a bin.
  }
  \item{chrs}{
    Vector containing list of chromosomes to include in output.
  }
  \item{minNormQual}{
    Quality threshold to use for filtering; SNPs with lower than this value are excluded.  This quality is any metric that provides the confidence of the locus being a true germline heterozygous SNP. 
  }
  \item{genomeStyle}{
  	The genome style to use for chromosomes. Use one of \sQuote{NCBI} or \sQuote{UCSC}. It does not matter what style is found in \code{inCounts}, \code{genomeStyle} will be the style returned. Invokes \code{\link{setGenomeStyle}}. 
  }
  \item{sep}{
    Character indicating the delimiter used for the columns for \code{infile}. Default is tab-delimited, "\\t".
  }
  \item{header}{
  	\code{logical} to indicate if the input tumour counts file contains a header line.
  }
  \item{seqinfo}{
    \code{\link[GenomeInfoDb:Seqinfo-class]{Seqinfo-class}} object describing chromosome information. If \code{NULL}, then will load seqinfo for hg19 \verb{system.files('extdata', 'Seqinfo_hg19.rda', package='TitanCNA'}.
  }
}

\value{
	\code{loadHaplotypeAlleleCounts} returns a \link[data.table]{data.table} containing components for 
  \item{chr}{Chromosome; character, \code{genomeStyle} naming convention}
  \item{posn}{Position; integer}
  \item{phaseSet}{Phase block identifier, numeric or character}
  \item{refOriginal}{Reference allele read count at SNP; numeric}
  \item{tumDepthOriginal}{Coverage at SNP; numeric}
  \item{ref}{Phased allele count values of higher coverage haplotype based on approach used (SNP, sum, mean); numeric}
  \item{nonRef}{Phased allele count values of lower coverage haplotype; tumDepth minus ref; numeric}
  \item{tumDepth}{Mean or sum of SNP read coverage; numeric}
  \item{HapltypeRatio}{Sum of read coverage of phased alleles of higher coverage haplotype normalized by \code{tumDepth}; numeric}
  \item{haplotypeCount}{Phased allele read count; numeric}
}

\references{
Ha, G., Roth, A., Khattra, J., Ho, J., Yap, D., Prentice, L. M., Melnyk, N., McPherson, A., Bashashati, A., Laks, E., Biele, J., Ding, J., Le, A., Rosner, J., Shumansky, K., Marra, M. A., Huntsman, D. G., McAlpine, J. N., Aparicio, S. A. J. R., and Shah, S. P. (2014). TITAN: Inference of copy number architectures in clonal cell populations from tumour whole genome sequence data. Genome Research, 24: 1881-1893. (PMID: 25060187)
}

\author{
  Gavin Ha <gavinha@gmail.com>
}

\seealso{
  \code{\link{loadDefaultParameters}}, \code{\link{plotHaplotypeFraction}}
}


\examples{
  \dontrun{
  infile <- "test_alleleCounts_chr2_with_phaseInfo.txt"
  haplotypeBinSize <- 1e5
  phaseSummarizeFun <- "sum"
  ## will load seqinfo_hg19 provided by TitanCNA package
  data <- loadHaplotypeAlleleCounts(infile, fun = phaseSummarizeFun,
      haplotypeBinSize = haplotypeBinSize, minSNPsInBin = 3, 
      chrs = c(1:22, "X"), minNormQual = 200, 
      genomeStyle = "NCBI", seqinfo = NULL)
  }
}


\keyword{IO}