# author: Helena L Crowell et al.
# ==============================================================================
# helpers to get metals & masses from channel names
get_ms   <- function(x) as.numeric(gsub("[[:alpha:][:punct:]]", "", x))
get_mets <- function(x) gsub("[[:digit:][:punct:]]*(Di)", "", x)

# ------------------------------------------------------------------------------
# color palette for 11 replicates & Fluidigm SM
palette <- c(
    'Uncompensated'='black', 
    'Fluidigm'='red2', 
    '160616'='darkviolet', 
    '160805'='hotpink',
    '161026_1'='gold1',
    '161026_2'='orange1', 
    '161026_3'='tomato',
    '161027'='cyan3', 
    '161028'='aquamarine4',
    'CyTOF-A_170530'='green4',  
    'CyTOF-A_170606'='limegreen',
    'CyTOF-B_170530'='blue3', 
    'CyTOF-B_170606'='dodgerblue')

# ------------------------------------------------------------------------------
# plots total ion load vs. spill [%] & [counts]
plot_load_vs_spill <- function(df, y, R2, beta, ylab, yscale) {
    p <- ggplot(df, aes_string(x="load", y=y, group="interaction")) + 
        ggtitle(paste0("R2 = ", R2, "\n", paste0("slope = ", beta))) +
        stat_smooth(formula=y~x, method="lm", fill=NA) +
        geom_point() + facet_grid(.~interaction) + yscale +
        scale_x_continuous(limits=c(2e3, 7e3), 
            breaks=seq(3e3,6e3,15e2), expand=c(0,0)) +
        labs(x="Total ion load", y=ylab) + theme_classic() + 
        theme(strip.background=element_rect(color="white"),
            panel.grid.major=element_line(size=.25, color="grey"),
            axis.text.x=element_text(angle=45, hjust=1))
    plot(p)
}

# ------------------------------------------------------------------------------
# plots overall spill received/caused across 
# 11 flow replicates, and Fluidigm matrix
plot_overall_spill <- function(df, title) {
    ggplot(df) + theme_classic() + ggtitle(title) + labs(x=NULL, y="Spillover [%]") + 
        geom_jitter(aes(x=Var1, y=value, col=Var2), width=.2, size=1.25, alpha=.75) +
        scale_y_continuous(limits=c(-.5,10.5), breaks=seq(0,12.5,2.5), expand=c(0,0)) +
        scale_color_manual(values=palette, name=NULL) +
        theme(axis.text.x=element_text(angle=45, vjust=1, hjust=1),
            panel.grid.major=element_line(size=.25, color="grey"))
}

# ------------------------------------------------------------------------------
# plots spill for ea. interaction & 11 flow replicates
plot_interactions <- function(df, title) {
    plot(ggplot(df) + labs(x=NULL, y="Spillover [%]") + ggtitle(title) +
            geom_jitter(aes(x=Var1, y=value, col=Var2), width=.2, size=1.5, alpha=.8) +
            scale_y_continuous(limits=c(-.5,5.5), breaks=seq(0,5,2.5), expand=c(0,0)) +
            scale_color_manual(values=palette, name=NULL) +
            theme_classic() + theme(panel.spacing=unit(0,"null"),
                axis.text.x=element_text(angle=45, vjust=1, hjust=1),
                panel.grid.major=element_line(size=.25, color="grey")))
}

# ------------------------------------------------------------------------------
# helper to get data.frame for error bars
get_bars <- function(i) { data.frame(
    x=rownames(spill)[groups[[i]]],
    y=means[[i]], min=mins[[i]], max=maxs[[i]],
    ymin=means[[i]]-sds[[i]], ymax=means[[i]]+sds[[i]])
}

# ------------------------------------------------------------------------------
# plots IMC spill for ea. interaction 
# w/ error bars for 11 flow replicates
plot_interactions_imc <- function(data, bars, imc, title) {
    plot(ggplot(melt(data)) + ggtitle(title) +
            geom_crossbar(data=bars, aes(x=x, y=y, ymin=ymin, ymax=ymax),
                fill="white", col="black", width=.5, size=.25) +
            geom_errorbar(data=bars, aes(x=x, ymin=min, ymax=max), width=.75, size=.25) +
            geom_jitter(data=imc, aes(x=x, y=y, col=as.factor(id)), width=.1, size=2) +
            theme_classic() + labs(x=NULL, y="Spillover [%]") +
            scale_x_discrete(limits=rownames(data)) +
            scale_y_continuous(limits=c(-.5,5.5), breaks=seq(0,5,2.5), expand=c(0,0)) +
            theme(legend.position="none",
                axis.text.x=element_text(angle=45, vjust=1, hjust=1),
                panel.grid.major=element_line(size=.25, color="grey")))
}

# ------------------------------------------------------------------------------
# plots median counts before & upon compensation using 
# population vs. single-cell based spill estimation
plot_method_comparison <- function(df) {
    p <- ggplot(df, aes(x=variable, y=value, col=variable)) + 
        geom_jitter(size=2, alpha=.3, width=.2) +
        scale_y_continuous(limits=c(-2.5,10), 
            breaks=c(-2.5,seq(0,10,5)), expand=c(.1,.1)) +
        labs(x=NULL, y="Median counts") + theme_classic() + 
        theme(legend.position="none",
            panel.grid.major=element_line(size=.25, color="grey"),
            axis.text.x=element_text(angle=90, vjust=.5, hjust=1))
    plot(p)
}

# ------------------------------------------------------------------------------
# wrapper to plot spillover matrix w/ 
# custom color palette & spill < 0.001 in black
plotSpillmat2 <- function(bc_ms, SM, norm_fact, main) {
    nms <- colnames(SM)
    ms <- as.numeric(regmatches(nms, gregexpr("[0-9]+", nms)))
    bc_cols <- which(ms %in% bc_ms)
    bc_range <- min(bc_cols) : max(bc_cols)
    SM <- CATALYST:::make_symetric(SM)[bc_range, bc_range]
    # set diagonal & spill < threshold to NA
    # & scale b/w 0 and 1 for visualization
    SM[row(SM) == col(SM) | SM*100 < .001] <- NA
    SM <- SM / norm_fact
    
    n <- length(bc_range)
    axis_labs <- nms[bc_range]
    lab_cols <- rep("grey", n)
    lab_cols[axis_labs %in% nms[bc_cols]] <- "black"
    
    df <- data.frame(c1=rep(1:n, n), 
        c2=rev(rep(1:n, each=n)), 
        spill=c(t(SM)))
    
    p <- ggplot(df, aes_string(x="c1", y="c2")) + ggtitle(main) +
        geom_tile(aes_string(fill="spill"), col="lightgrey") + 
        scale_fill_gradient2(low="aliceblue", midpoint=.5, na.value="black", 
            mid="cornflowerblue", high="darkblue", limits=c(0,1)) +
        scale_x_discrete(limits=1:n, expand=c(0,0), labels=axis_labs) +
        scale_y_discrete(limits=1:n, expand=c(0,0), labels=rev(axis_labs)) +
        coord_fixed() + xlab(NULL) + ylab(NULL) + theme_bw() + theme(
            panel.grid.major=element_blank(), panel.border=element_blank(),
            axis.text.x=element_text(vjust=.5, size=6, angle=90),
            axis.text.y=element_text(vjust=.5, size=6, color=rev(lab_cols)))
    plot(p)
}

# ------------------------------------------------------------------------------
# plots spill for classic vs. default estimation method,
# delta [%] (difference in estaimtes), and ratio of delate to spill [%]
plot_classic_vs_default <- function(df1, df2, df3) {
    p1 <- ggplot(df1) + scale_x_discrete(expand=c(0,1)) +
        geom_point(aes(x=Var1, y=value, col=Var2), size=2.5, alpha=.75, stroke=.5) +
        scale_color_discrete(name=NULL) + labs(x=NULL, y="Spillover [%]") +
        scale_y_continuous(limits=c(0,4.5), breaks=0:4, expand=c(0,0)) +
        theme_classic() + theme(
            legend.position=c(.2,.9),
            panel.grid.major.y=element_line(size=.25, color="grey"),
            axis.text.x=element_text(angle=45, hjust=1, vjust=1, size=8))
    
    p2 <- ggplot(df2, aes(x=x, y=y)) + 
        geom_point(size=2.5, alpha=.5, stroke=.5) +
        stat_smooth(formula=y~x, method="lm", col="red3", fill=NA, size=.75) +
        geom_hline(yintercept=0, size=.5) +
        labs(x=NULL, y=expression(Delta*" [%]")) +
        scale_x_continuous(expand=c(0,1)) +
        scale_y_continuous(limits=c(-.225,.125), 
            breaks=seq(-.2,.1,.1), expand=c(0,0)) +
        theme_classic() + theme(axis.line.x=element_blank(),
            axis.text.x=element_blank(), axis.ticks.x=element_blank(),
            panel.grid.major.y=element_line(size=.25, color="grey"))
    
    p3 <- ggplot(df3, aes(x=x, y=y)) +
        geom_point(size=2.5, alpha=.5, stroke=.5) + 
        stat_smooth(formula=y~x, method="lm", col="red3", fill=NA, size=.75) +
        geom_hline(yintercept=0, size=.5) +
        labs(x=NULL, y=expression(paste(Delta*" / Spillover [%]"))) +
        scale_x_continuous(expand=c(0,1)) +
        scale_y_continuous(limits=c(-11,1), breaks=seq(-10,0,5), expand=c(0,0)) +
        theme_classic() + theme(axis.line.x=element_blank(),
            axis.text.x=element_blank(), axis.ticks.x=element_blank(),
            panel.grid.major.y=element_line(size=.25, color="grey"))
    
    # align widths & plot
    gA <- ggplotGrob(p1)
    gB <- ggplotGrob(p2)
    gC <- ggplotGrob(p3)
    gA$widths <- gB$widths
    gC$widths <- gB$widths
    grid.arrange(gA, gB, gC, nrow=3, heights=c(6,3,3))
}

# ------------------------------------------------------------------------------
# plots medians before & upon compensation for single replicate
# (single-stained beads + multiplexed cells)
plot_before_vs_after <- function(df, df_mse) {
    p <- ggplot(df, aes(x=x, y=value, col=variable)) +
        geom_hline(yintercept=0, lty=3, size=.5) +
        geom_jitter(width=.25, alpha=.25, size=2.5, stroke=.5) + 
        geom_text(data=df_mse, aes(x=x, y=y, label=mse),
            inherit.aes=FALSE, angle=30, size=3, vjust=.5) +
        guides(color=guide_legend(override.aes=list(alpha=1))) +
        scale_color_discrete(NULL, labels=c("Uncompensated", "Compensated", "NNLS compensated")) +
        scale_x_discrete(limits=c(2,6), labels=c("Single-stained\nbeads", "Multiplexed cells")) +
        scale_y_continuous(limits=c(-12.5,93.75), breaks=seq(0,75,25), expand=c(0,0)) +
        theme_classic() + labs(x=NULL, y="Median counts") +
        theme(panel.grid.major.y=element_line(size=.25, color="grey"))
    plot(p)
}

# ------------------------------------------------------------------------------
# plots medians before & upon compensation across replicates
plot_med_counts <-  function(df, vline, yscale) {
    p <- ggplot(df) + geom_jitter(aes(x=variable, y=value, col=variable), 
        width=.2, alpha=.25, size=2.5, stroke=.25) + guides(col=FALSE) +
        scale_color_manual(values=palette) +
        geom_text(aes(x=as.factor(x), y=y, label=z),
            inherit.aes=FALSE, data=err, angle=90, vjust=.5) +
        # vertical line to indicate which beads medians were computed from
        # (compensation should be most accurate here!)
        geom_vline(xintercept=vline, lty=2, size=.25) + 
        geom_hline(yintercept=0, lty=3, size=.5) + yscale +
        theme_classic() + labs(x=NULL, y="Median counts upon compensation") +
        theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1),
            panel.grid.major.x=element_line(size=.25, color="grey"))
    plot(p)
}